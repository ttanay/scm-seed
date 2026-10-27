(define (descend n) (if (= n 0) (error "bottom reached") (+ 1 (descend (- n 1)))))
'start
(descend 100)
'unreachable
