(define (loop n k) (if (= n 0) (k 'done) (loop (- n 1) k)))
(loop 1000000 (lambda (x) x))
(define (bounce f g n) (if (= n 0) 'bounced (f g f (- n 1))))
(bounce bounce bounce 1000000)
