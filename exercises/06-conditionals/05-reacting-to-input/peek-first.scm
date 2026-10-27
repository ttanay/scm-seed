(if (= (char->integer (peek-char)) 45) (write-char #\-) (write-char #\+))
(write-char (read-char))
(write-char #\newline)
