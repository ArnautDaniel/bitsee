(declare (uses tcp posix))

;;;Work out topology
(define (start-video x)
  (process (string-append "omxplayer --win \"0 0 640 480\" -o local rtsp://admin:123456@"
                          x
                          "/profile1")))

(define *current-camera-count*)
(define *current-host* "10.0.0.40")
(define *current-port-no* 6508)

(define (grab-camera-ips)
  (define-values (i o) (tcp-connect *current-host* *current-port-no*))
  (define (recur-ip)
    (if (eof-object? (peek-char i))
        '()
        (cons (read-line i) (recur-ip)))))

(define *camera-list* (grab-camera-ips))

(define (start-cameras)
  (map start-video *camera-list*))

;;;TODO Topology with omx options
