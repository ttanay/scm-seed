(define (list . xs) xs)
(define-macro (a x) (list 'b x))
(define-macro (b x) (list 'quote x))
(a hello)
