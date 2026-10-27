(define (loop n) (if (= n 0) 'done (apply loop (cons (- n 1) '()))))
(loop 1000000)
