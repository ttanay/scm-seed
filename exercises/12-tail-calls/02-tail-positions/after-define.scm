(define (loop n)
  (define m (- n 1))
  (if (< m 0) 'ok (loop m)))
(loop 1000000)
