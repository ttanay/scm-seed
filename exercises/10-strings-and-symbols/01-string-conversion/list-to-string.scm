(list->string (cons #\h (cons #\i '())))
(list->string '())
(list->string (string->list "round trip"))
(list->string (cons #\" (cons #\newline '())))
