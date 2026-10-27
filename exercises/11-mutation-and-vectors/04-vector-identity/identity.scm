(define v (make-vector 2 0))
(eq? v v)
(eq? (make-vector 1 0) (make-vector 1 0))
(define p (cons 1 2))
(define w (make-vector 2 p))
(eq? (vector-ref w 0) (vector-ref w 1))
(set-car! (vector-ref w 0) 9)
w
