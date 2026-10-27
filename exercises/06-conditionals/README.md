# Section 6: Conditionals

The first special form that chooses what to evaluate. With `if`, programs can make decisions, including decisions about their input.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §3.2 Truthiness, §5.4 if.

It also contributes to: §9.9 Input and output (completed in section 5), §10 Errors (completed in section 13).

## Stages

- [ ] [6.1 if](#61-if)
- [ ] [6.2 Truthiness](#62-truthiness)
- [ ] [6.3 if without an alternative](#63-if-without-an-alternative)
- [ ] [6.4 Only one branch runs](#64-only-one-branch-runs)
- [ ] [6.5 Reacting to input](#65-reacting-to-input)
- [ ] [6.6 Malformed if](#66-malformed-if)

---

## 6.1 if

**Spec:** §5.4 if

Implement support for:

- The special form `(if test consequent alternative)`. If `test` gives anything other than `#f`, evaluate and return `consequent`; otherwise evaluate and return `alternative`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 6.1`

| Test | Checks | Expects |
|---|---|---|
| [`basic`](01-if/basic.scm) | choosing a branch | output |
| [`as-value`](01-if/as-value.scm) | if is an expression | output |
| [`computed-branches`](01-if/computed-branches.scm) | branches can be any expression | output |

---

## 6.2 Truthiness

**Spec:** §3.2 Truthiness

Implement support for:

- Only `#f` counts as false. Every other value, including `0`, `()`, and `""`, counts as true.

Run: `./run-tests.py --impl "YOUR-COMMAND" 6.2`

| Test | Checks | Expects |
|---|---|---|
| [`only-false-is-false`](02-truthiness/only-false-is-false.scm) | values that count as true | output |
| [`predicate-results`](02-truthiness/predicate-results.scm) | predicates return real booleans | output |

---

## 6.3 if without an alternative

**Spec:** §5.4 if, §3.2 Truthiness

Implement support for:

- `(if test consequent)`. When `test` is `#f`, the result is the unspecified value.
- In `--print` mode, the unspecified value is not printed at top level. Nested inside another value, it prints as `#<unspecified>`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 6.3`

| Test | Checks | Expects |
|---|---|---|
| [`one-armed`](03-one-armed-if/one-armed.scm) | one-armed if | output |
| [`nested-unspecified`](03-one-armed-if/nested-unspecified.scm) | the unspecified value inside a pair | output |

---

## 6.4 Only one branch runs

**Spec:** §5.4 if

Implement support for:

- `if` evaluates only the branch it chooses. The other branch may contain errors or output that must never happen.

Run: `./run-tests.py --impl "YOUR-COMMAND" 6.4`

| Test | Checks | Expects |
|---|---|---|
| [`errors-skipped`](04-one-branch/errors-skipped.scm) | the branch not taken can hold errors | output |
| [`output-skipped`](04-one-branch/output-skipped.scm) | the branch not taken can hold output | output (run mode) |

---

## 6.5 Reacting to input

**Spec:** §5.4 if, §9.9 Input and output

**Mode:** run (plain `IMPL FILE...`)

Implement support for:

- Programs that branch on what they read, including noticing the end of input.

Run: `./run-tests.py --impl "YOUR-COMMAND" 6.5`

| Test | Checks | Expects |
|---|---|---|
| [`answer`](05-reacting-to-input/answer.scm) | branching on input | output (stdin) |
| [`eof`](05-reacting-to-input/eof.scm) | noticing the end of input | output (stdin) |
| [`peek-first`](05-reacting-to-input/peek-first.scm) | looking ahead before reading | output (stdin) |

---

## 6.6 Malformed if

**Spec:** §5.4 if, §10 Errors

Implement support for:

- Signaling an error for an `if` with too few or too many parts, and for an error while evaluating the test.

Run: `./run-tests.py --impl "YOUR-COMMAND" 6.6`

| Test | Checks | Expects |
|---|---|---|
| [`empty`](06-if-errors/empty.scm) | (if) | error |
| [`test-only`](06-if-errors/test-only.scm) | (if #t) | error |
| [`too-many`](06-if-errors/too-many.scm) | (if #t 1 2 3) | error |
| [`test-fails`](06-if-errors/test-fails.scm) | an error in the test | error |
