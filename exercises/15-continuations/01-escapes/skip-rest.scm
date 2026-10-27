(call/cc (lambda (k) (write-char #\a) (k 'escaped) (write-char #\b)))
