(define a (char->integer (read-char)))
(define b (char->integer (read-char)))
(if (< a b) (write-char #\<) (if (= a b) (write-char #\=) (write-char #\>)))
(write-char #\newline)
