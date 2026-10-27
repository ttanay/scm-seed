# Section 15: Continuations

First-class continuations with `call/cc`. The first stages only escape: they call a continuation while its `call/cc` is still active. From stage 15.5 on, continuations are re-entered after their `call/cc` has returned, any number of times.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §8 Continuations, §9.8 Control.

It also contributes to: §7 Proper tail recursion (completed in section 12), §10 Errors (completed in section 13).

## Stages

- [ ] [15.1 Escaping with call/cc](#151-escaping-with-callcc)
- [ ] [15.2 Escaping from recursion](#152-escaping-from-recursion)
- [ ] [15.3 Continuations are procedures](#153-continuations-are-procedures)
- [ ] [15.4 call/cc and tail calls](#154-callcc-and-tail-calls)
- [ ] [15.5 Re-entering continuations](#155-re-entering-continuations)
- [ ] [15.6 Generators](#156-generators)
- [ ] [15.7 Backtracking](#157-backtracking)
- [ ] [15.8 Top-level continuations](#158-top-level-continuations)

---

## 15.1 Escaping with call/cc

**Spec:** §8 Continuations

Implement support for:

- The primitive `call/cc`, which calls its argument with the current continuation. Calling the continuation with a value abandons the current computation and makes `call/cc` return that value.
- If the continuation is never called, `call/cc` returns whatever its argument returns.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.1`

| Test | Checks | Expects |
|---|---|---|
| [`escape`](01-escapes/escape.scm) | escaping out of an expression | output |
| [`skip-rest`](01-escapes/skip-rest.scm) | the rest of the computation is abandoned | output |

---

## 15.2 Escaping from recursion

**Spec:** §8 Continuations

Implement support for:

- Escapes from deep, non-tail recursion, from inside other procedures, and from inside higher-order procedures.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.2`

| Test | Checks | Expects |
|---|---|---|
| [`search`](02-escaping-recursion/search.scm) | stopping a search early | output |
| [`deep`](02-escaping-recursion/deep.scm) | escaping from non-tail recursion | output |
| [`passed-along`](02-escaping-recursion/passed-along.scm) | a continuation passed to another procedure | output |
| [`from-map`](02-escaping-recursion/from-map.scm) | escaping from inside map | output |

---

## 15.3 Continuations are procedures

**Spec:** §8 Continuations, §9.8 Control, §10 Errors

Implement support for:

- A continuation is an ordinary procedure of exactly one argument: `procedure?` is true of it, and it can be passed to `apply`.
- `call/cc` accepts any procedure, including a primitive.
- Signaling an error for a continuation called with the wrong number of arguments, and for a bad argument to `call/cc`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.3`

| Test | Checks | Expects |
|---|---|---|
| [`procedures`](03-continuation-procedures/procedures.scm) | continuations are procedures | output |
| [`arity-zero`](03-continuation-procedures/arity-zero.scm) | a continuation called with no arguments | error |
| [`arity-two`](03-continuation-procedures/arity-two.scm) | a continuation called with two arguments | error |
| [`non-procedure`](03-continuation-procedures/non-procedure.scm) | (call/cc 5) | error |
| [`call-cc-arity`](03-continuation-procedures/call-cc-arity.scm) | (call/cc) | error |

---

## 15.4 call/cc and tail calls

**Spec:** §7 Proper tail recursion, §8 Continuations

Implement support for:

- `call/cc` calls its argument as a tail call.
- Repeated escapes run in bounded space.

> **Note:** These tests run a million iterations.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.4`

| Test | Checks | Expects |
|---|---|---|
| [`tail-call`](04-call-cc-tail-calls/tail-call.scm) | a loop through call/cc | output |
| [`many-escapes`](04-call-cc-tail-calls/many-escapes.scm) | a million escapes | output |

---

## 15.5 Re-entering continuations

**Spec:** §8 Continuations

Implement support for:

- Continuations have unlimited extent: they can be called after their `call/cc` has returned, any number of times, even after the procedure that captured them has returned.
- Re-entering a continuation does not undo assignments made since it was captured.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.5`

| Test | Checks | Expects |
|---|---|---|
| [`loop`](05-reentry/loop.scm) | re-entering a continuation to loop | output |
| [`internal-define`](05-reentry/internal-define.scm) | re-entering the continuation of an internal definition | output |
| [`after-return`](05-reentry/after-return.scm) | re-entering a procedure that has returned | output |
| [`state-survives`](05-reentry/state-survives.scm) | assignments are not undone | output |

---

## 15.6 Generators

**Spec:** §8 Continuations

Implement support for:

- Generators built from two continuations, one to return each value and one to resume the walk.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.6`

| Test | Checks | Expects |
|---|---|---|
| [`leaves`](06-generators/leaves.scm) | the leaves of a tree, one at a time | output |
| [`same-fringe`](06-generators/same-fringe.scm) | comparing two trees leaf by leaf | output |

---

## 15.7 Backtracking

**Spec:** §8 Continuations

Implement support for:

- Search with backtracking: a choice point that can be resumed with its next alternative whenever a later step fails.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.7`

| Test | Checks | Expects |
|---|---|---|
| [`triples`](07-backtracking/triples.scm) | every Pythagorean triple up to 20 | output |

---

## 15.8 Top-level continuations

**Spec:** §8 Continuations

**Mode:** run (plain `IMPL FILE...`)

Implement support for:

- Continuations captured by one top-level form and called from a later one, as specified in §8.2: the rest of the earlier form runs, then evaluation continues with the form after the one that called the continuation.

Run: `./run-tests.py --impl "YOUR-COMMAND" 15.8`

| Test | Checks | Expects |
|---|---|---|
| [`reenter-earlier-form`](08-top-level/reenter-earlier-form.scm) | re-entering an earlier top-level form | output |
