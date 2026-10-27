(define-macro (my-quote x) (cons 'quote (cons x '())))
(my-quote (a b c))
(my-quote hello)
