(define (spam n) (if (< 0 n) (begin (write-char #\.) (spam (- n 1)))))
(spam 5000)
(error "after lots of output")
