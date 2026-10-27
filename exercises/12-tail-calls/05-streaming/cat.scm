(define (echo)
  (define c (read-char))
  (if (eof-object? c) 'done (begin (write-char c) (echo))))
(echo)
