(begin (write-char #\a) (write-char #\b) (write-char #\newline))
(begin (begin (write-char #\1)) (begin (write-char #\2) (begin (write-char #\3))))
(write-char #\newline)
