(define (f k) (g k) 'not-reached)
(define (g k) (k 'escaped))
(call/cc f)
