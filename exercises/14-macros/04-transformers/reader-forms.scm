(define (list . xs) xs)
(define-macro (show-form x) (list 'quote x))
(show-form `(a ,b ,@c))
(show-form 'x)
