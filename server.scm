(require-extension tcp-server posix)
(declare (uses tcp posix srfi-18))

(define (generate-ip-port str)
  (define-values (ip ip2 ip3)
    (process
     (string-append "~/bitsee/find-network.sh " str)))
  (generate-ip-lst ip))

(define (generate-ip-lst ipp)
  (if (eof-object? (peek-char ipp))
      '()
      (cons (read-line ipp) (generate-ip-lst ipp))))

(define (start-server)
  (define *camera-ips* (generate-ip-port "10.0.0.0/24"))
  (define *fake-camera-ips* '("10.0.0.23" "10.0.0.3" "10.32.3.4"))
  ((make-tcp-server
    (tcp-listen 6509)
    (lambda () (map (lambda (x)
                      (write-line x))
                    *camera-ips*)))
   #t))

(thread-start! (make-thread (lambda () (start-server))))

(thread-start!
 (make-thread
  (lambda ()
    (process "ffmpeg -i rtsp://admin:123456@10.0.0.48/profile1 -rtsp_transport tcp -r 10 -vcodec copy -an -t 900 output.mkv -y
"))))
