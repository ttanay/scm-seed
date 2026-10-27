(define (loop n) (if (= n 0) 'done (call/cc (lambda (k) (loop (- n 1))))))
(loop 1000000)
