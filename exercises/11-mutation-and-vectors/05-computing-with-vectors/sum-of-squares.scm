(define v (make-vector 10 0))
(define (fill! i) (if (< i 10) (begin (vector-set! v i (* i i)) (fill! (+ i 1)))))
(fill! 0)
v
(define (sum i acc) (if (< i 10) (sum (+ i 1) (+ acc (vector-ref v i))) acc))
(sum 0 0)
