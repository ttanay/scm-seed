(define x 'global)
(define get-x (lambda () x))
((lambda (x) (get-x)) 'caller)
