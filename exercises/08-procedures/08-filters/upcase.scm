(define (lower? c) (if (< 96 (char->integer c)) (< (char->integer c) 123) #f))
(define (upcase c) (if (lower? c) (integer->char (- (char->integer c) 32)) c))
(define (filter c)
  (if (eof-object? c)
      #f
      ((lambda (ignore) (filter (read-char))) (write-char (upcase c)))))
(filter (read-char))
