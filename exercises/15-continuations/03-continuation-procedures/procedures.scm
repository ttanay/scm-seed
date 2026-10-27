(call/cc (lambda (k) (procedure? k)))
(call/cc procedure?)
(call/cc (lambda (k) (apply k '(7))))
