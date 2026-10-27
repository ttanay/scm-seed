(define (write-all cs) (if (pair? cs) (begin (write-char (car cs)) (write-all (cdr cs)))))
(define (write-string s) (write-all (string->list s)))
(define (copy-line)
  (define c (read-char))
  (if (eof-object? c) #f
      (if (= (char->integer c) 10) #f
          (begin (write-char c) (copy-line)))))
(write-string "Hello, ")
(copy-line)
(write-string "! You are ")
(copy-line)
(write-string ".\n")
