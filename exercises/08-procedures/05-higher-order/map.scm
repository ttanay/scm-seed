(define (map1 f l) (if (pair? l) (cons (f (car l)) (map1 f (cdr l))) '()))
(map1 (lambda (x) (* x x)) '(1 2 3 4))
(map1 car '((a 1) (b 2)))
(map1 (lambda (x) x) '())
