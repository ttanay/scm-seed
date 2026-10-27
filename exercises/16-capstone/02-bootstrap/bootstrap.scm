;; The code below is copied verbatim from spec.md, Appendix B.

(define (list . xs) xs)
(define (null? x) (eq? x '()))
(define (not x) (if x #f #t))
(define (boolean? x) (if (eq? x #t) #t (eq? x #f)))
(define (cadr x) (car (cdr x)))
(define (cddr x) (cdr (cdr x)))
(define (caar x) (car (car x)))

(define (map1 f xs)
  (if (null? xs) '() (cons (f (car xs)) (map1 f (cdr xs)))))

(define (append2 a b)
  (if (null? a) b (cons (car a) (append2 (cdr a) b))))

(define (eqv? a b)
  (if (eq? a b) #t
      (if (number? a)
          (if (number? b) (= a b) #f)
          (if (char? a)
              (if (char? b) (= (char->integer a) (char->integer b)) #f)
              #f))))

(define (fold-left f acc xs)
  (if (null? xs) acc (fold-left f (f acc (car xs)) (cdr xs))))

(define +
  ((lambda (add) (lambda xs (fold-left add 0 xs)))
   +))

(define -
  ((lambda (sub)
     (lambda (x . xs)
       (if (null? xs) (sub 0 x) (fold-left sub x xs))))
   -))

(define-macro (let bindings . body)
  (cons (cons 'lambda (cons (map1 car bindings) body))
        (map1 cadr bindings)))

(define-macro (and . xs)
  (if (null? xs) #t
      (if (null? (cdr xs)) (car xs)
          (list 'if (car xs) (cons 'and (cdr xs)) #f))))

(define-macro (or . xs)
  (if (null? xs) #f
      (if (null? (cdr xs)) (car xs)
          (let ((t (gensym)))
            (list 'let (list (list t (car xs)))
                  (list 'if t t (cons 'or (cdr xs))))))))

(define-macro (cond . clauses)
  (if (null? clauses)
      '(if #f #f)
      (let ((c (car clauses)))
        (if (eq? (car c) 'else)
            (cons 'begin (cdr c))
            (list 'if (car c)
                  (cons 'begin (cdr c))
                  (cons 'cond (cdr clauses)))))))
;; Left as exercises: clauses with no body, `=>` clauses, named let, let*, letrec.

;; Quasiquote without nesting levels (see [Bawden 1999] for the full algorithm).
(define (qq-expand x)
  (cond ((not (pair? x)) (list 'quote x))
        ((eq? (car x) 'unquote) (cadr x))
        ((and (pair? (car x)) (eq? (caar x) 'unquote-splicing))
         (list 'append2 (cadr (car x)) (qq-expand (cdr x))))
        (else (list 'cons (qq-expand (car x)) (qq-expand (cdr x))))))

(define-macro (quasiquote x) (qq-expand x))

(define (newline) (write-char #\newline))

(define (display-string s)
  (for-each-char write-char (string->list s)))
(define (for-each-char f cs)
  (if (null? cs) #t (begin (f (car cs)) (for-each-char f (cdr cs)))))

(define (display-integer n)
  (if (< n 0)
      (begin (write-char #\-) (display-digits (- 0 n)))
      (display-digits n)))
(define (display-digits n)            ; n ≥ 0
  (if (< n 10)
      (write-char (integer->char (+ 48 n)))
      (begin (display-digits (quotient n 10))
             (write-char (integer->char (+ 48 (remainder n 10)))))))

(define *winders* '())

(define (dynamic-wind before thunk after)
  (before)
  (set! *winders* (cons (cons before after) *winders*))
  (let ((result (thunk)))
    (set! *winders* (cdr *winders*))
    (after)
    result))

;; Then redefine call/cc so that each captured continuation records
;; *winders*. On invocation it runs the `after` thunks of the frames being
;; left and the `before` thunks of the frames being entered (common-ancestor
;; walk), and only then calls the raw continuation.
;; See [Dybvig 2009] and [R7RS §6.10].

;; ---- program ----
(print (let ((x 2) (y 3)) (* x y)))
(print (and 1 2 3))
(print (and 1 #f 3))
(print (or #f 7))
(print (or #f #f))
(print (cond ((< 2 1) 'no) ((< 1 2) 'yes) (else 'never)))
(print (cond (#f 1) (else 'fallback)))
(print `(1 ,(+ 1 1) ,@(list 3 4) five))
(print (+ 1 2 3 4))
(print (+))
(print (- 10 1 2))
(print (- 5))
(print (eqv? #\a #\a))
(print (eqv? 'a 'b))
(display-integer -1234)
(newline)
(display-string "hello from the library")
(newline)
(print (dynamic-wind (lambda () (display-string "[in]"))
                     (lambda () 'during)
                     (lambda () (display-string "[out]"))))
