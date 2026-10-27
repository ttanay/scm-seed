(define a (cons 1 '()))
(define b (cons 0 a))
(set-car! a 2)
b
