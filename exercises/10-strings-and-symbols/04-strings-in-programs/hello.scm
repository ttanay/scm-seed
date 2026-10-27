(define (write-all cs) (if (pair? cs) (begin (write-char (car cs)) (write-all (cdr cs)))))
(define (write-string s) (write-all (string->list s)))
(write-string "Hello, world!\n")
