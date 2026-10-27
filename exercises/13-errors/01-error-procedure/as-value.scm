(procedure? error)
(define (fail-with f) (f "via a variable"))
'calling
(fail-with error)
