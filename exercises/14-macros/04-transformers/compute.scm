(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))
(define-macro (fact-at-expansion n) (fact n))
(fact-at-expansion 5)
