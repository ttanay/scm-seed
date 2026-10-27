(define (map1 f l) (if (pair? l) (cons (f (car l)) (map1 f (cdr l))) '()))
(define (negate-all l)
  (call/cc
    (lambda (k)
      (map1 (lambda (x) (if (number? x) (- 0 x) (k 'not-a-number))) l))))
(negate-all '(1 2 3))
(negate-all '(1 a 3))
