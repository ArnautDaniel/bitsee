
(use tcp posix)
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


;;;
(define (check-length lst)
  (let ((len (length lst)))
    (if (prime? len)
        (+ len 1)
        len)))

(define (generate-fact-pair n)
  (let ((fact (factors n 2)))
    (if (= (length fact) 1)
        (list (first fact) 1)
        (list (list-ref fact (- (length fact) 2))
              (list-ref fact (- (length fact) 3))))))

(define (start-cameras cam-lst)
  (let* ((len (check-length cam-lst))
        (fact-pair (generate-fact-pair len))
        (camera-grid (find-grid 1080 1920 (iota len 1)
                                (first fact-pair)
                                (second fact-pair))))
    camera-grid))

;;;Calculate grid based on (length *camera-list*) [DONE]
;;;Calculate total window size (e.g. 640x480)
;;;Call start-video with all 3 values
;;;Map this process

;;;TODO Topology with omx options [IN PROGRESS]

;;;Calulate n_x for p = GCF(#ofcameras) and n_x = which number screen
;;;res = total width of screen
(define (find-x res n p) (* res (/ (remainder (- n 1) p) p)))

;;;Find y coordinate.  higher p = more rows
;;; higher r = more columns
(define (find-y res n p r) (* res (/ (floor (/ (- n 1) p)) r)))

;;;ex (find-grid 1080 1920 #cameras #highestfactorwithinR #R)
(define (find-grid res-h res-w n p r)
  (map
   (lambda (x)
     (list (find-x res-w x p) (find-y res-h x p r)))
   n))

;;;To find a 2 * 3 column p > r
;;;To find a 3 * 2 column r > p
;;;To find a n+1 * n column p > r
;;;To find a n * n+1 column r > p

(define (factors n f)
  (let loop ((f f) (acc '()))
    (cond ((> f n) (reverse acc))
          ((zero? (remainder n f))
           (loop (add1 f) (cons f acc)))
          (else (loop (add1 f) acc)))))


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
