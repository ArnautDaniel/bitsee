;;; omxplayer --win "0 0 640 480" -o local rtsp://admin:123456@ip/profile1

(declare (uses tcp posix))

(define-values (i o) (tcp-connect "10.0.0.40" 6508))

(define (start-video x)
  (process (string-append "omxplayer --win \"0 0 640 480\" -o local rtsp://admin:123456@" x "/profile1")))

(start-video (read-line i))
