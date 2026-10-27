# Section 11: Mutation and vectors

Mutable data: pairs whose halves can be replaced, and vectors, which give constant-time access to their elements. This completes the core's data types.

**Mode:** `--print` for every test in this section.

## Unlocks

Completing this section **unlocks**: §3.1 Disjoint types, §9.1 Pairs, §9.2 Type predicates, §9.7 Vectors.

It also contributes to: §9.3 Identity (completed in section 4), §10 Errors (completed in section 13).

## Stages

- [ ] [11.1 Mutating pairs](#111-mutating-pairs)
- [ ] [11.2 Circular structure](#112-circular-structure)
- [ ] [11.3 Vectors](#113-vectors)
- [ ] [11.4 vector? and identity](#114-vector?-and-identity)
- [ ] [11.5 Computing with vectors](#115-computing-with-vectors)
- [ ] [11.6 Runtime errors: mutation and vectors](#116-runtime-errors-mutation-and-vectors)

---

## 11.1 Mutating pairs

**Spec:** §9.1 Pairs

Implement support for:

- The primitives `set-car!` and `set-cdr!`, which replace the halves of a pair. Their value is unspecified.
- A change to a pair is visible through every reference to it.

Run: `./run-tests.py --impl "YOUR-COMMAND" 11.1`

| Test | Checks | Expects |
|---|---|---|
| [`set-car-cdr`](01-pair-mutation/set-car-cdr.scm) | replacing the halves of a pair | output |
| [`shared`](01-pair-mutation/shared.scm) | mutation through a shared tail | output |
| [`reverse-in-place`](01-pair-mutation/reverse-in-place.scm) | destructive reversal | output |
| [`queue`](01-pair-mutation/queue.scm) | a queue with a tail pointer | output |

---

## 11.2 Circular structure

**Spec:** §9.1 Pairs, §9.3 Identity

Implement support for:

- Pairs that refer to themselves, directly or indirectly.

> **Note:** No test prints a circular structure, since the output format has no way to show one.

Run: `./run-tests.py --impl "YOUR-COMMAND" 11.2`

| Test | Checks | Expects |
|---|---|---|
| [`ring`](02-circular/ring.scm) | a one-element ring | output |
| [`cycle`](02-circular/cycle.scm) | a two-element cycle | output |

---

## 11.3 Vectors

**Spec:** §9.7 Vectors

Implement support for:

- The primitives `make-vector`, `vector-length`, `vector-ref`, and `vector-set!`.
- In `--print` mode, a vector prints as `#(` elements `)`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 11.3`

| Test | Checks | Expects |
|---|---|---|
| [`make`](03-vectors/make.scm) | creating vectors | output |
| [`ref-set`](03-vectors/ref-set.scm) | reading and writing elements | output |
| [`nested`](03-vectors/nested.scm) | vectors inside other values | output |

---

## 11.4 vector? and identity

**Spec:** §9.2 Type predicates, §3.1 Disjoint types, §9.3 Identity

Implement support for:

- The predicate `vector?`. Vectors are not pairs, procedures, or any other type.
- Each `make-vector` call makes a new vector, and every element starts as the same fill object.

Run: `./run-tests.py --impl "YOUR-COMMAND" 11.4`

| Test | Checks | Expects |
|---|---|---|
| [`predicate`](04-vector-identity/predicate.scm) | vector? and disjointness | output |
| [`identity`](04-vector-identity/identity.scm) | vector identity and shared fill | output |
| [`any-element`](04-vector-identity/any-element.scm) | vectors hold any objects | output |

---

## 11.5 Computing with vectors

**Spec:** §9.7 Vectors

Implement support for:

- Programs that use vectors as tables: filling, summing, and sieving.

Run: `./run-tests.py --impl "YOUR-COMMAND" 11.5`

| Test | Checks | Expects |
|---|---|---|
| [`sum-of-squares`](05-computing-with-vectors/sum-of-squares.scm) | filling and summing a vector | output |
| [`sieve`](05-computing-with-vectors/sieve.scm) | the sieve of Eratosthenes | output |

---

## 11.6 Runtime errors: mutation and vectors

**Spec:** §9.1 Pairs, §9.7 Vectors, §10 Errors

Implement support for:

- Signaling an error for out-of-range indices, negative lengths, and arguments of the wrong type.

Run: `./run-tests.py --impl "YOUR-COMMAND" 11.6`

| Test | Checks | Expects |
|---|---|---|
| [`ref-past-end`](06-mutation-errors/ref-past-end.scm) | index equal to the length | error |
| [`ref-negative`](06-mutation-errors/ref-negative.scm) | negative index | error |
| [`set-out-of-range`](06-mutation-errors/set-out-of-range.scm) | vector-set! out of range | error |
| [`negative-length`](06-mutation-errors/negative-length.scm) | make-vector with a negative length | error |
| [`ref-list`](06-mutation-errors/ref-list.scm) | vector-ref of a list | error |
| [`length-pair`](06-mutation-errors/length-pair.scm) | vector-length of a pair | error |
| [`set-car-empty`](06-mutation-errors/set-car-empty.scm) | set-car! of the empty list | error |
| [`set-cdr-arity`](06-mutation-errors/set-cdr-arity.scm) | set-cdr! with one argument | error |
