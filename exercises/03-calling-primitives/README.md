# Section 3: Calling primitives

Procedure calls, using the built-in primitives. You don't need user-defined procedures yet: these all exist in the global environment from the start.

**Mode:** `--print` for every test in this section.

## Unlocks

Completing this section **unlocks**: §3.3 Integers, §5.2 Procedure call, §9.4 Integer primitives, §9.5 Characters.

It also contributes to: §9.2 Type predicates (completed in section 11), §10 Errors (completed in section 13).

## Stages

- [ ] [3.1 Addition and subtraction](#31-addition-and-subtraction)
- [ ] [3.2 Multiplication and division](#32-multiplication-and-division)
- [ ] [3.3 Nested calls](#33-nested-calls)
- [ ] [3.4 Comparison](#34-comparison)
- [ ] [3.5 Type predicates](#35-type-predicates)
- [ ] [3.6 Characters and code points](#36-characters-and-code-points)
- [ ] [3.7 Runtime errors: types](#37-runtime-errors-types)
- [ ] [3.8 Runtime errors: calls](#38-runtime-errors-calls)

---

## 3.1 Addition and subtraction

**Spec:** §5.2 Procedure call, §9.4 Integer primitives

Implement support for:

- Procedure calls `(operator operand ...)`: evaluate the operator and the operands, then apply the procedure to the values.
- The primitives `+` and `-`, each taking exactly two integers.

> **Note:** In this stage the operands are always literals. Nested calls come in stage 3.3.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.1`

| Test | Checks | Expects |
|---|---|---|
| [`add`](01-add-subtract/add.scm) | addition | output |
| [`subtract`](01-add-subtract/subtract.scm) | subtraction | output |
| [`spacing`](01-add-subtract/spacing.scm) | a call spread over lines | output |

---

## 3.2 Multiplication and division

**Spec:** §9.4 Integer primitives, §3.3 Integers

Implement support for:

- The primitives `*`, `quotient`, and `remainder`, each taking exactly two integers.
- `quotient` truncates toward zero; `remainder` has the sign of its first argument.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.2`

| Test | Checks | Expects |
|---|---|---|
| [`multiply`](02-multiply-divide/multiply.scm) | multiplication | output |
| [`quotient`](02-multiply-divide/quotient.scm) | quotient truncates toward zero | output |
| [`remainder`](02-multiply-divide/remainder.scm) | remainder has the sign of the dividend | output |
| [`range`](02-multiply-divide/range.scm) | results in the minimum required range | output |

---

## 3.3 Nested calls

**Spec:** §5.2 Procedure call

Implement support for:

- Operands that are themselves procedure calls, to any depth.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.3`

| Test | Checks | Expects |
|---|---|---|
| [`two-levels`](03-nested-calls/two-levels.scm) | a call with calls as operands | output |
| [`deep`](03-nested-calls/deep.scm) | deeply nested calls | output |
| [`mixed`](03-nested-calls/mixed.scm) | different primitives together | output |

---

## 3.4 Comparison

**Spec:** §9.4 Integer primitives

Implement support for:

- The primitives `=` and `<`, each taking exactly two integers and returning `#t` or `#f`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.4`

| Test | Checks | Expects |
|---|---|---|
| [`equal`](04-comparison/equal.scm) | = | output |
| [`less`](04-comparison/less.scm) | < | output |
| [`with-arithmetic`](04-comparison/with-arithmetic.scm) | comparing computed values | output |

---

## 3.5 Type predicates

**Spec:** §9.2 Type predicates

Implement support for:

- The predicates `number?`, `char?`, `string?`, `symbol?`, and `procedure?`. Each takes one argument of any type and returns `#t` or `#f`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.5`

| Test | Checks | Expects |
|---|---|---|
| [`number`](05-type-predicates/number.scm) | number? | output |
| [`char`](05-type-predicates/char.scm) | char? | output |
| [`string`](05-type-predicates/string.scm) | string? | output |
| [`symbol`](05-type-predicates/symbol.scm) | symbol? | output |
| [`procedure`](05-type-predicates/procedure.scm) | procedure? | output |
| [`results`](05-type-predicates/results.scm) | predicates return booleans | output |

---

## 3.6 Characters and code points

**Spec:** §9.5 Characters

Implement support for:

- The primitives `char->integer` and `integer->char`, converting between characters and Unicode code points.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.6`

| Test | Checks | Expects |
|---|---|---|
| [`char-to-integer`](06-characters/char-to-integer.scm) | char->integer | output |
| [`integer-to-char`](06-characters/integer-to-char.scm) | integer->char | output |
| [`round-trip`](06-characters/round-trip.scm) | computing with characters | output |

---

## 3.7 Runtime errors: types

**Spec:** §9.4 Integer primitives, §9.5 Characters, §10 Errors

Implement support for:

- Signaling an error when a primitive gets an argument of the wrong type.
- Output printed before the error still appears.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.7`

| Test | Checks | Expects |
|---|---|---|
| [`add-boolean`](07-type-errors/add-boolean.scm) | (+ 1 #t) | error |
| [`add-symbol`](07-type-errors/add-symbol.scm) | (+ 'a 1) | error |
| [`subtract-string`](07-type-errors/subtract-string.scm) | (- "5" 1) | error |
| [`compare-chars`](07-type-errors/compare-chars.scm) | (< #\a #\b) | error |
| [`char-to-integer`](07-type-errors/char-to-integer.scm) | (char->integer 65) | error |
| [`integer-to-char`](07-type-errors/integer-to-char.scm) | (integer->char #\a) | error |
| [`partial-output`](07-type-errors/partial-output.scm) | an error after some output | error |

---

## 3.8 Runtime errors: calls

**Spec:** §5.2 Procedure call, §9.4 Integer primitives, §9.5 Characters, §10 Errors

Implement support for:

- Signaling an error for division by zero, for the wrong number of arguments to a primitive, for calling something that is not a procedure, and for code points that are not Unicode scalar values.

Run: `./run-tests.py --impl "YOUR-COMMAND" 3.8`

| Test | Checks | Expects |
|---|---|---|
| [`quotient-by-zero`](08-call-errors/quotient-by-zero.scm) | (quotient 1 0) | error |
| [`remainder-by-zero`](08-call-errors/remainder-by-zero.scm) | (remainder 1 0) | error |
| [`too-few`](08-call-errors/too-few.scm) | (+ 1) | error |
| [`too-many`](08-call-errors/too-many.scm) | (+ 1 2 3) | error |
| [`predicate-arity`](08-call-errors/predicate-arity.scm) | (number? 1 2) | error |
| [`call-integer`](08-call-errors/call-integer.scm) | (1 2 3) | error |
| [`call-string`](08-call-errors/call-string.scm) | ("f" 1) | error |
| [`call-symbol`](08-call-errors/call-symbol.scm) | ('car '(1)) | error |
| [`negative-code-point`](08-call-errors/negative-code-point.scm) | (integer->char -1) | error |
| [`surrogate`](08-call-errors/surrogate.scm) | (integer->char 55296) | error |
