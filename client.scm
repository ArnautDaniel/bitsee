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
  (define )
  (map start-video *camera-list*))
;;;Steps to starting camera
;;;Calculate grid based on (length *camera-list*)
;;;Calculate total window size (e.g. 640x480)
;;;Call start-video with all 3 values
;;;Map this process somehow
;;;Figure out data structs

;;;TODO Topology with omx options

;;;Calulate n_x for p = GCF(#ofcameras) and n_x = which number screen
;;;res = total width of screen
(define (find-x res n p) (* res (/ (remainder (- n 1) p) p)))

;;;Find y coordinate.  higher p = more rows
;;; higher r = more columns
(define (find-y res n p r) (* res (/ (floor (/ (- n 1) p)) r)))

(define (find-grid res-h res-w n p r)
  (map
   (lambda (x)
     (list (find-x res-w x p) (find-y res-h x p r)))
   n))

;;;To find a 2 * 3 column p > r
;;;To find a 3 * 2 column r > p
;;;To find a n+1 * n column p > r
;;;To find a n * n+1 column r > p
