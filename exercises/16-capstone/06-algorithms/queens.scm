(define (ok? row dist placed)
  (if (pair? placed)
      (if (= (car placed) row) #f
      (if (= (car placed) (+ row dist)) #f
      (if (= (car placed) (- row dist)) #f
          (ok? row (+ dist 1) (cdr placed)))))
      #t))
(define (queens n)
  (define (place k placed)
    (if (= k 0) 1 (try 1 k placed)))
  (define (try row k placed)
    (if (< n row)
        0
        (+ (if (ok? row 1 placed) (place (- k 1) (cons row placed)) 0)
           (try (+ row 1) k placed))))
  (place n '()))
(define (first-solution n)
  (call/cc
    (lambda (return)
      (define (place k placed)
        (if (= k 0) (return placed) (try 1 k placed)))
      (define (try row k placed)
        (if (< n row)
            #f
            (begin (if (ok? row 1 placed) (place (- k 1) (cons row placed)))
                   (try (+ row 1) k placed))))
      (place n '()))))
(print (queens 4))
(print (queens 6))
(print (queens 8))
(print (first-solution 8))
(print (first-solution 3))
