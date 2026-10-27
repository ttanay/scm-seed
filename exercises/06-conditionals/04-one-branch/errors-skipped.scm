(if #t 1 (car '()))
(if #f (car '()) 2)
(if #t 3 (undefined-procedure))
