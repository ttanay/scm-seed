(define (list . xs) xs)
(define n 0)
(define-macro (twice e) (list 'begin e e))
(define (f) (twice (set! n (+ n 1))))
(f)
(f)
n
