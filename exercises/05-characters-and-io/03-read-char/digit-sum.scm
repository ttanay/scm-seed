(write-char (integer->char (+ 48 (+ (- (char->integer (read-char)) 48)
                                     (- (char->integer (read-char)) 48)))))
(write-char #\newline)
