(define-macro (add-one x) (cons '+ (cons x (cons 1 '()))))
(add-one 41)
(add-one (* 2 3))
