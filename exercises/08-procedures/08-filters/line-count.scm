(define (digit d) (write-char (integer->char (+ 48 d))))
(define (count c n)
  (if (eof-object? c)
      n
      (count (read-char) (if (= (char->integer c) 10) (+ n 1) n))))
(digit (count (read-char) 0))
(write-char #\newline)
