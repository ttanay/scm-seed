(if #t (write-char #\a) (write-char #\b))
(if #f (write-char #\c) (write-char #\d))
(if #t (write-char #\newline))
