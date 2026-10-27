(define x 'global)
(define (f) (define x 'local) x)
(f)
x
