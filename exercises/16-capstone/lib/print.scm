;;; print.scm: a printer written in Seed.
;;;
;;; The capstone programs load this file before running. It uses only core
;;; features, so it runs on any interpreter that has passed sections 1-15.
;;;
;;;   (print obj)      writes obj in the harness output format, then a newline
;;;   (write-obj obj)  writes obj in the harness output format
;;;   (write-chars l)  writes a list of characters

(define (print x)
  (write-obj x)
  (write-char #\newline))

(define (write-obj x)
  (if (eq? x #t) (write-chars (string->list "#t"))
  (if (eq? x #f) (write-chars (string->list "#f"))
  (if (eq? x '()) (write-chars (string->list "()"))
  (if (number? x) (write-int x)
  (if (symbol? x) (write-chars (string->list (symbol->string x)))
  (if (string? x) (write-string-literal x)
  (if (char? x) (write-char-literal x)
  (if (pair? x) (write-pair x)
  (if (procedure? x) (write-chars (string->list "#<procedure>"))
  (if (vector? x) (write-vector x)
  (if (eof-object? x) (write-chars (string->list "#<eof>"))
      (write-chars (string->list "#<unspecified>"))))))))))))))

(define (write-chars cs)
  (if (pair? cs)
      (begin (write-char (car cs))
             (write-chars (cdr cs)))))

(define (write-int n)
  (if (< n 0)
      (begin (write-char #\-) (write-digits (- 0 n)))
      (write-digits n)))

(define (write-digits n)
  (if (< n 10)
      (write-char (integer->char (+ 48 n)))
      (begin (write-digits (quotient n 10))
             (write-char (integer->char (+ 48 (remainder n 10)))))))

(define (write-string-literal s)
  (write-char #\")
  (write-escaped (string->list s))
  (write-char #\"))

(define (write-escaped cs)
  (if (pair? cs)
      (begin (write-escaped-char (car cs))
             (write-escaped (cdr cs)))))

(define (write-escaped-char c)
  (if (= (char->integer c) 34) (begin (write-char #\\) (write-char #\"))
  (if (= (char->integer c) 92) (begin (write-char #\\) (write-char #\\))
  (if (= (char->integer c) 10) (begin (write-char #\\) (write-char #\n))
  (if (= (char->integer c) 9)  (begin (write-char #\\) (write-char #\t))
      (write-char c))))))

(define (write-char-literal c)
  (write-char #\#)
  (write-char #\\)
  (if (= (char->integer c) 32) (write-chars (string->list "space"))
  (if (= (char->integer c) 10) (write-chars (string->list "newline"))
  (if (= (char->integer c) 9)  (write-chars (string->list "tab"))
      (write-char c)))))

(define (write-pair p)
  (write-char #\()
  (write-obj (car p))
  (write-tail (cdr p))
  (write-char #\)))

(define (write-tail x)
  (if (pair? x)
      (begin (write-char #\space)
             (write-obj (car x))
             (write-tail (cdr x)))
      (if (eq? x '())
          #f
          (begin (write-chars (string->list " . "))
                 (write-obj x)))))

(define (write-vector v)
  (write-char #\#)
  (write-char #\()
  (write-vector-from v 0)
  (write-char #\)))

(define (write-vector-from v i)
  (if (< i (vector-length v))
      (begin (if (< 0 i) (write-char #\space))
             (write-obj (vector-ref v i))
             (write-vector-from v (+ i 1)))))
