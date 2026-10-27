(define (list . xs) xs)
(define-macro (my-and . xs)
  (if (eq? xs '()) #t
      (if (eq? (cdr xs) '()) (car xs)
          (list 'if (car xs) (cons 'my-and (cdr xs)) #f))))
(my-and)
(my-and 1 2 3)
(my-and 1 #f (car '()))
