(define (count-up i n) (if (= i n) i (count-up (+ i 1) n)))
(count-up 0 1000000)
