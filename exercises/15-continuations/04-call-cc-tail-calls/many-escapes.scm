(define (loop n) (if (= n 0) 'done (loop (call/cc (lambda (k) (k (- n 1)))))))
(loop 1000000)
