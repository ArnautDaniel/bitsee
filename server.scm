(require-extension tcp-server posix)
(declare (uses tcp posix))

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
(define *fake-camera-ips* '("10.0.0.23" "10.0.0.3" "10.32.3.4"))

((make-tcp-server
  (tcp-listen 6508)
  (lambda () (map (lambda (x)
         (write-line x))
       *fake-camera-ips*)))
 #t)
