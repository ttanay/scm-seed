(define (range a b) (if (< b a) '() (cons a (range (+ a 1) b))))
(apply (lambda args args) (range 1 5))
(apply (lambda (a b . more) more) (range 1 5))
