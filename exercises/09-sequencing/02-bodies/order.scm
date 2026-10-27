(define (f) (write-char #\a) (write-char #\b) #\c)
(write-char (f))
((lambda (x) (write-char x) (write-char x)) #\d)
(write-char #\newline)
