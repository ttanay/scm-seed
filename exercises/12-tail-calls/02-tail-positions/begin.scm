(define (loop n) (if (= n 0) 'done (begin 'ignored (loop (- n 1)))))
(loop 1000000)
