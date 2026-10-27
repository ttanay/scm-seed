(define visited '())
(define (product l)
  (call/cc
    (lambda (break)
      (define (walk l)
        (if (pair? l)
            (begin (set! visited (cons (car l) visited))
                   (if (= (car l) 0) (break 0) (* (car l) (walk (cdr l)))))
            1))
      (walk l))))
(product '(1 2 3 4))
(product '(5 0 7 8))
visited
