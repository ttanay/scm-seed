(define (compose f g) (lambda (x) (f (g x))))
(define (twice f) (compose f f))
((twice (lambda (n) (+ n 1))) 5)
((compose car cdr) '(1 2 3))
