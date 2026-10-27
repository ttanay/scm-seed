(define x 'global)
((lambda (x) x) 'local)
x
((lambda (x) ((lambda (x) x) 'inner)) 'outer)
((lambda (car) car) 'shadowed)
(car '(1))
