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

(define *camera-ips* (generate-ip-port "10.0.0.0/24"))

(define (start-server)
  ((make-tcp-server
    (tcp-listen 6509)
    (lambda () (map (lambda (x)
                      (write-line x))
                    *camera-ips*)))
   #t))

(thread-start! (make-thread (lambda () (start-server))))

(define (record-stream ip)
  (thread-start!
   (make-thread
    (lambda ()
      (process (string-append "ffmpeg -i rtsp://admin:123456@"
                              ip
                              "/profile1 -rtsp_transport tcp -r 10 -vcodec copy -y -segment_time"
                              *segment-duration*
                              "-f segment -an camera-1-%03d.mkv"))))))

;;;Perhaps a symbol list for disabling/enabling ffmpeg options?
;;;Or a text file?

;;;Length of video files
(define *segment-duration* "30")

(define (record-all)
  (map record-stream *camera-ips*))

(record-all)


