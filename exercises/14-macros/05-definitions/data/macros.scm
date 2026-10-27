(define-macro (swap-pair p) (cons 'quote (cons (cons (cdr p) (car p)) '())))
