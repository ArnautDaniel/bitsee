
(use tcp posix numbers srfi-1)
(define *height* 1080)
(define *width* 1920)

;;;Work out topology
(define (start-video x)
  (process (string-append "omxplayer --win \"0 0 640 480\" -o local rtsp://admin:123456@"
                          x
                          "/profile1")))

(define (start-mpv ip x y gx gy)
  (process (string-append "mpv --screen=1 --no-border --geometry=" x "x" y "-" gx "-" gy
                          " rtsp://admin:123456@" ip "/profile1")))

(define *current-host* "192.168.1.78")
(define *current-port-no* 6508)

(define (grab-camera-ips)
     (define-values (i o) (tcp-connect *current-host* *current-port-no*))
     (define (recur-ip)
            (if (eof-object? (peek-char i))
                         '()
                         (cons (read-line i) (recur-ip))))
     (recur-ip))

 (define *camera-list* (grab-camera-ips))

;;;Test of a 3x2 grid [works]
;;;Need to solve the p and r problem so this
;;;can do this automatically
(define (start-cameras cam-lst)
  (let* ((len (no-primes (length cam-lst)))
        (camera-grid (find-grid *width* *height* (iota len 1)))
        (resW
         (inexact->exact (find-res-h *width* len)))
        (resH
         (inexact->exact (find-res-w *height* len)))
        (zipped (zip cam-lst camera-grid)))

    (map (lambda (x)
           (start-mpv (first x)
                      (number->string resW)
                      (number->string resH)
                      (number->string (inexact->exact (first (second x))))
                      (number->string (inexact->exact (second (second x))))))
         zipped)))


;;;Calculate grid based on (length *camera-list*) [DONE]
;;;Calculate total window size (e.g. 640x480) [LAST TODO]
;;;Call start-video with all 3 values [DONE]
;;;Map this process [DONE]

;;;TODO Topology with omx options [IN PROGRESS]

;;;Calulate n_x for p = GCF(#ofcameras) and n_x = which number screen
;;;res = total width of screen
(define (find-x res n p) (* res (/ (remainder (- n 1) p) p)))

;;;Find y coordinate.  higher p = more rows
;;; higher r = more columns
(define (find-y res n p r) (* res (/ (floor (/ (- n 1) p)) r)))

;;;ex (find-grid 1080 1920 #cameras #highestfactorwithinR #R)
(define (find-grid res-h res-w n)
  (let* ((len (length n))
         (p (find-p len))
         (r (find-r len)))
  (map
   (lambda (x)
     (list (find-x res-h x p) (find-y res-w x p r)))
   n)))

(define (find-res-h scrn-size numcam)
  (* scrn-size (/ 1 (find-p numcam))))

(define (find-res-w scrn-size numcam)
  (* scrn-size (/ 1 (find-r numcam))))


(define (no-primes n)
  (if (prime? n)
      (+ n 1)
      n))

(define (find-p c)
  (let ((c-sqrt (floor (sqrt c))))
    (let g ((cur-n c-sqrt))
      (cond ((zero? (modulo c cur-n))
             (inexact->exact cur-n))
            (else
             (g (- cur-n 1)))))))

(define (find-r c)
  (/ c (find-p c)))

;;;Sicp lol
(define (square x) (* x x))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        (( divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

