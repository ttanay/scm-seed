(define (copy-line)
  (define c (read-char))
  (if (eof-object? c)
      #f
      (if (= (char->integer c) 10)
          #f
          (begin (write-char c) (copy-line)))))
(write-char #\>) (write-char #\space)
(copy-line)
(write-char #\newline)
(write-char #\>) (write-char #\space)
(copy-line)
(write-char #\newline)
