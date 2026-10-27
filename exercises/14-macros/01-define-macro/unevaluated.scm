(define-macro (ignore x) #t)
(ignore (undefined-procedure 1 2))
