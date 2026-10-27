(define c (cons 'o '()))
(set-cdr! c c)
(car (cdr (cdr (cdr c))))
(eq? c (cdr c))
