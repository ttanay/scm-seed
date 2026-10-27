(define (list . xs) xs)
(define-macro (my-if c a b) (list 'if c a b))
(define (count n) (my-if (= n 0) 'ok (count (- n 1))))
(count 1000000)
