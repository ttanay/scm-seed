(define (echo c)
  (if (eof-object? c)
      #f
      ((lambda (ignore) (echo (read-char))) (write-char c))))
(echo (read-char))
