(define (fold f acc l) (if (pair? l) (fold f (f acc (car l)) (cdr l)) acc))
(fold + 0 '(1 2 3 4 5))
(fold (lambda (acc x) (cons x acc)) '() '(1 2 3))
