# Section 4: Pairs

Pairs are the building block of every Scheme data structure, and of Scheme programs themselves. This section adds the primitives that build and take apart pairs, and `eq?`, which compares objects by identity.

**Mode:** `--print` for every test in this section.

## Unlocks

Completing this section **unlocks**: §9.3 Identity.

It also contributes to: §3.1 Disjoint types (completed in section 11), §9.1 Pairs (completed in section 11), §9.2 Type predicates (completed in section 11), §10 Errors (completed in section 13).

## Stages

- [ ] [4.1 cons, car, and cdr](#41-cons,-car,-and-cdr)
- [ ] [4.2 pair? and the empty list](#42-pair?-and-the-empty-list)
- [ ] [4.3 Identity with eq?](#43-identity-with-eq?)
- [ ] [4.4 Runtime errors: pairs](#44-runtime-errors-pairs)

---

## 4.1 cons, car, and cdr

**Spec:** §9.1 Pairs

Implement support for:

- The primitive `cons`, which returns a new pair.
- The primitives `car` and `cdr`, which return the two halves of a pair.

Run: `./run-tests.py --impl "YOUR-COMMAND" 4.1`

| Test | Checks | Expects |
|---|---|---|
| [`cons`](01-cons-car-cdr/cons.scm) | building pairs and lists | output |
| [`car-cdr`](01-cons-car-cdr/car-cdr.scm) | taking lists apart | output |
| [`of-cons`](01-cons-car-cdr/of-cons.scm) | car and cdr of a new pair | output |
| [`dotted`](01-cons-car-cdr/dotted.scm) | the tail of an improper list | output |

---

## 4.2 pair? and the empty list

**Spec:** §9.2 Type predicates, §3.1 Disjoint types

Implement support for:

- The predicate `pair?`.
- The empty list is not a pair, and not a symbol, number, or procedure.

Run: `./run-tests.py --impl "YOUR-COMMAND" 4.2`

| Test | Checks | Expects |
|---|---|---|
| [`pair`](02-pair-predicate/pair.scm) | pair? | output |
| [`empty-list`](02-pair-predicate/empty-list.scm) | the empty list | output |
| [`disjoint`](02-pair-predicate/disjoint.scm) | pairs are not other types | output |

---

## 4.3 Identity with eq?

**Spec:** §9.3 Identity

Implement support for:

- The primitive `eq?`, which returns `#t` when its two arguments are the same object.
- Symbols with the same name are the same object. So are the two booleans and the empty list.
- Every `cons` makes a new pair.

Run: `./run-tests.py --impl "YOUR-COMMAND" 4.3`

| Test | Checks | Expects |
|---|---|---|
| [`symbols`](03-eq/symbols.scm) | symbols | output |
| [`booleans-and-empty`](03-eq/booleans-and-empty.scm) | booleans and the empty list | output |
| [`pairs`](03-eq/pairs.scm) | separately built pairs are different | output |
| [`procedures`](03-eq/procedures.scm) | a procedure is itself | output |
| [`disjoint`](03-eq/disjoint.scm) | objects of different types | output |

---

## 4.4 Runtime errors: pairs

**Spec:** §9.1 Pairs, §10 Errors

Implement support for:

- Signaling an error for `car` or `cdr` of something that is not a pair, and for the wrong number of arguments to the pair primitives.

Run: `./run-tests.py --impl "YOUR-COMMAND" 4.4`

| Test | Checks | Expects |
|---|---|---|
| [`car-empty`](04-pair-errors/car-empty.scm) | (car '()) | error |
| [`cdr-number`](04-pair-errors/cdr-number.scm) | (cdr 5) | error |
| [`car-symbol`](04-pair-errors/car-symbol.scm) | (car 'a) | error |
| [`cons-one`](04-pair-errors/cons-one.scm) | (cons 1) | error |
| [`cons-three`](04-pair-errors/cons-three.scm) | (cons 1 2 3) | error |
| [`car-two`](04-pair-errors/car-two.scm) | (car '(1) '(2)) | error |
| [`eq-one`](04-pair-errors/eq-one.scm) | (eq? 1) | error |
