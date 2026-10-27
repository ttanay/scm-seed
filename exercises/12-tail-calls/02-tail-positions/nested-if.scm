(define (loop n)
  (if (< n 1)
      'done
      (if (= (remainder n 2) 0)
          (loop (- n 1))
          (if #f 'never (loop (- n 1))))))
(loop 1000000)
