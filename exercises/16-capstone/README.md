# Section 16: Capstone

No new features. These are larger programs that use the whole language together. When they all pass, your interpreter implements the whole Seed core. Every test here loads [`lib/print.scm`](lib/print.scm), a printer written in Seed, before running.

**Mode:** run (plain `IMPL FILE...`) for every test in this section.

## Unlocks

Completing this section **unlocks**: §11 Conformance.

It also contributes to: §6 Macros (completed in section 14), §8 Continuations (completed in section 15), §9.9 Input and output (completed in section 5).

## Stages

- [ ] [16.1 A printer in Seed](#161-a-printer-in-seed)
- [ ] [16.2 Bootstrapping a library](#162-bootstrapping-a-library)
- [ ] [16.3 A metacircular evaluator](#163-a-metacircular-evaluator)
- [ ] [16.4 A reader in Seed](#164-a-reader-in-seed)
- [ ] [16.5 A REPL in Seed](#165-a-repl-in-seed)
- [ ] [16.6 Algorithms](#166-algorithms)
- [ ] [16.7 Objects and threads](#167-objects-and-threads)

---

## 16.1 A printer in Seed

**Spec:** §11 Conformance

Implement support for:

- Running `lib/print.scm`, a Seed program that prints values in the harness output format using only `write-char`.

> **Note:** If this test fails while every earlier stage passes, look for a core feature that `lib/print.scm` uses in a way the earlier tests don't.

Run: `./run-tests.py --impl "YOUR-COMMAND" 16.1`

| Test | Checks | Expects |
|---|---|---|
| [`printer`](01-printer/printer.scm) | printing every kind of value from Seed | output (several files) |

---

## 16.2 Bootstrapping a library

**Spec:** §11 Conformance, §6 Macros

Implement support for:

- Running the library excerpts from the spec's Appendix B: `list`, `let`, `and`, `or`, `cond`, `quasiquote`, variadic `+` and `-`, `eqv?`, output procedures, and `dynamic-wind`, all written in Seed.

Run: `./run-tests.py --impl "YOUR-COMMAND" 16.2`

| Test | Checks | Expects |
|---|---|---|
| [`bootstrap`](02-bootstrap/bootstrap.scm) | Appendix B, then a program that uses it | output (several files) |

---

## 16.3 A metacircular evaluator

**Spec:** §11 Conformance

Implement support for:

- Running an evaluator for a small Lisp, written in Seed.

Run: `./run-tests.py --impl "YOUR-COMMAND" 16.3`

| Test | Checks | Expects |
|---|---|---|
| [`metacircular`](03-metacircular/metacircular.scm) | an evaluator written in Seed | output (several files) |

---

## 16.4 A reader in Seed

**Spec:** §11 Conformance, §9.9 Input and output

Implement support for:

- Running a reader for Seed data, written in Seed, that parses standard input.

Run: `./run-tests.py --impl "YOUR-COMMAND" 16.4`

| Test | Checks | Expects |
|---|---|---|
| [`reader`](04-reader/reader.scm) | parsing standard input in Seed | output (stdin, several files) |

---

## 16.5 A REPL in Seed

**Spec:** §11 Conformance, §9.9 Input and output

Implement support for:

- Running a read-eval-print loop that combines the reader and the evaluator from the previous two stages.

> **Note:** This is a REPL running on your interpreter. To use it interactively, run `IMPL exercises/16-capstone/lib/print.scm exercises/16-capstone/05-repl/repl.scm` and type expressions.

Run: `./run-tests.py --impl "YOUR-COMMAND" 16.5`

| Test | Checks | Expects |
|---|---|---|
| [`repl`](05-repl/repl.scm) | a read-eval-print loop over standard input | output (stdin, several files) |

---

## 16.6 Algorithms

**Spec:** §11 Conformance

Implement support for:

- Running search and arbitrary-precision arithmetic: counting and finding N-queens solutions, and bignum factorials, powers, and Fibonacci numbers built from small integers.

Run: `./run-tests.py --impl "YOUR-COMMAND" 16.6`

| Test | Checks | Expects |
|---|---|---|
| [`queens`](06-algorithms/queens.scm) | N-queens | output (several files) |
| [`bignum`](06-algorithms/bignum.scm) | bignum arithmetic | output (several files) |

---

## 16.7 Objects and threads

**Spec:** §11 Conformance, §8 Continuations

Implement support for:

- Running message-passing objects built from closures, and cooperative threads built from continuations.

Run: `./run-tests.py --impl "YOUR-COMMAND" 16.7`

| Test | Checks | Expects |
|---|---|---|
| [`objects`](07-objects-and-threads/objects.scm) | message-passing objects and a queue | output (several files) |
| [`coroutines`](07-objects-and-threads/coroutines.scm) | a round-robin scheduler | output (several files) |
