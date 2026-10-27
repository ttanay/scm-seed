(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
(fact 10)
(define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
(fib 15)
