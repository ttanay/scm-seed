(+ 1 (call/cc (lambda (k) (+ 10 (k 1)))))
(call/cc (lambda (k) 42))
