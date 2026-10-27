# Section 8: Procedures

User-defined procedures: the heart of the language. In this section every procedure body is a single expression; bodies with several forms come in section 9.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §4.2 Environments and variables.

It also contributes to: §5.5 lambda (completed in section 9), §5.6 define (completed in section 9), §9.8 Control (completed in section 15), §9.9 Input and output (completed in section 5), §10 Errors (completed in section 13).

## Stages

- [ ] [8.1 lambda without parameters](#81-lambda-without-parameters)
- [ ] [8.2 Parameters](#82-parameters)
- [ ] [8.3 Named procedures and recursion](#83-named-procedures-and-recursion)
- [ ] [8.4 Closures](#84-closures)
- [ ] [8.5 Higher-order procedures](#85-higher-order-procedures)
- [ ] [8.6 Rest parameters](#86-rest-parameters)
- [ ] [8.7 apply](#87-apply)
- [ ] [8.8 Filters over standard input](#88-filters-over-standard-input)
- [ ] [8.9 Runtime errors: procedures](#89-runtime-errors-procedures)

---

## 8.1 lambda without parameters

**Spec:** §5.5 lambda

Implement support for:

- The special form `(lambda () body)`, which creates a procedure. Calling it evaluates `body` and returns the result.
- A procedure made by `lambda` prints as `#<procedure>`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.1`

| Test | Checks | Expects |
|---|---|---|
| [`call`](01-lambda/call.scm) | creating and calling procedures | output |
| [`each-call-evaluates`](01-lambda/each-call-evaluates.scm) | the body runs on each call, not when the procedure is made | output |

---

## 8.2 Parameters

**Spec:** §5.5 lambda, §4.2 Environments and variables

Implement support for:

- `(lambda (x ...) body)`: each call binds the parameters to the arguments in a new environment whose parent is the environment where the procedure was created.
- Parameters shadow outer bindings, including primitives.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.2`

| Test | Checks | Expects |
|---|---|---|
| [`parameters`](02-parameters/parameters.scm) | procedures with parameters | output |
| [`shadowing`](02-parameters/shadowing.scm) | parameters shadow outer bindings | output |
| [`lexical-scope`](02-parameters/lexical-scope.scm) | free variables are found where the procedure was made | output |

---

## 8.3 Named procedures and recursion

**Spec:** §5.6 define, §5.5 lambda

Implement support for:

- Procedures stored in global variables, and the shorthand `(define (name param ...) body)`.
- Recursion, and procedures that refer to globals defined after them.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.3`

| Test | Checks | Expects |
|---|---|---|
| [`named`](03-named-procedures/named.scm) | naming procedures | output |
| [`recursion`](03-named-procedures/recursion.scm) | recursive procedures | output |
| [`forward-reference`](03-named-procedures/forward-reference.scm) | referring to a procedure defined later | output |

---

## 8.4 Closures

**Spec:** §5.5 lambda, §4.2 Environments and variables

Implement support for:

- Procedures keep the environment they were created in, even after the procedure that created them has returned.
- Closures that share a variable see each other's changes to it.
- A closure that refers to a global sees later changes to that global.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.4`

| Test | Checks | Expects |
|---|---|---|
| [`make-adder`](04-closures/make-adder.scm) | procedures that make procedures | output |
| [`counter`](04-closures/counter.scm) | closures with state | output |
| [`sees-redefinition`](04-closures/sees-redefinition.scm) | globals are looked up when used | output |

---

## 8.5 Higher-order procedures

**Spec:** §5.5 lambda

Implement support for:

- Procedures as arguments and as results.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.5`

| Test | Checks | Expects |
|---|---|---|
| [`compose`](05-higher-order/compose.scm) | composing procedures | output |
| [`map`](05-higher-order/map.scm) | mapping over a list | output |
| [`fold`](05-higher-order/fold.scm) | folding a list | output |

---

## 8.6 Rest parameters

**Spec:** §5.5 lambda, §5.6 define

Implement support for:

- `(lambda args body)`, which binds `args` to a new list of all the arguments.
- `(lambda (a b . rest) body)`, which binds any arguments after the required ones to a new list.
- The same shapes in the `define` shorthand: `(define (f . args) ...)` and `(define (f a . rest) ...)`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.6`

| Test | Checks | Expects |
|---|---|---|
| [`all-args`](06-rest-parameters/all-args.scm) | collecting every argument | output |
| [`dotted`](06-rest-parameters/dotted.scm) | required and rest parameters | output |
| [`define-shorthand`](06-rest-parameters/define-shorthand.scm) | rest parameters in define | output |

---

## 8.7 apply

**Spec:** §9.8 Control

Implement support for:

- The primitive `apply`, which calls a procedure with the elements of a list as its arguments. The core `apply` takes exactly two arguments.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.7`

| Test | Checks | Expects |
|---|---|---|
| [`apply`](07-apply/apply.scm) | applying procedures to lists | output |
| [`computed-arguments`](07-apply/computed-arguments.scm) | an argument list built at run time | output |

---

## 8.8 Filters over standard input

**Spec:** §5.5 lambda, §9.9 Input and output

**Mode:** run (plain `IMPL FILE...`)

Implement support for:

- Recursive programs that process all of their input, one character at a time, until the end.

> **Note:** These tests use small inputs. Section 12 makes the same kind of program work on inputs of any size.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.8`

| Test | Checks | Expects |
|---|---|---|
| [`cat`](08-filters/cat.scm) | copying standard input to standard output | output (stdin) |
| [`upcase`](08-filters/upcase.scm) | upper-casing every letter | output (stdin) |
| [`line-count`](08-filters/line-count.scm) | counting lines | output (stdin) |

---

## 8.9 Runtime errors: procedures

**Spec:** §5.5 lambda, §9.8 Control, §10 Errors

Implement support for:

- Signaling an error when a procedure is called with the wrong number of arguments, for a malformed `lambda`, and for `apply` with a non-procedure, an improper list, or the wrong number of arguments.

Run: `./run-tests.py --impl "YOUR-COMMAND" 8.9`

| Test | Checks | Expects |
|---|---|---|
| [`too-few`](09-procedure-errors/too-few.scm) | too few arguments | error |
| [`too-many`](09-procedure-errors/too-many.scm) | too many arguments | error |
| [`too-few-rest`](09-procedure-errors/too-few-rest.scm) | too few arguments with a rest parameter | error |
| [`named-arity`](09-procedure-errors/named-arity.scm) | arity is checked for named procedures | error |
| [`no-body`](09-procedure-errors/no-body.scm) | (lambda (x)) | error |
| [`bad-formals`](09-procedure-errors/bad-formals.scm) | (lambda (1) 1) | error |
| [`bad-define-name`](09-procedure-errors/bad-define-name.scm) | (define (1 x) x) | error |
| [`apply-improper`](09-procedure-errors/apply-improper.scm) | (apply + (cons 1 2)) | error |
| [`apply-non-procedure`](09-procedure-errors/apply-non-procedure.scm) | (apply 5 '()) | error |
| [`apply-arity`](09-procedure-errors/apply-arity.scm) | (apply +) | error |
