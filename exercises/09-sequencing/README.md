# Section 9: Sequencing

Do several things in a row, and give procedures their own local definitions. This completes `lambda`, `define`, and `begin`.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §5.5 lambda, §5.6 define, §5.8 begin.

It also contributes to: §4.2 Environments and variables (completed in section 8), §9.9 Input and output (completed in section 5).

## Stages

- [ ] [9.1 begin](#91-begin)
- [ ] [9.2 Procedure bodies](#92-procedure-bodies)
- [ ] [9.3 Internal definitions](#93-internal-definitions)
- [ ] [9.4 begin and definitions](#94-begin-and-definitions)
- [ ] [9.5 Interactive programs](#95-interactive-programs)

---

## 9.1 begin

**Spec:** §5.8 begin

Implement support for:

- The special form `(begin form ...)`, which evaluates its forms in order and returns the value of the last.
- `(begin)` at top level, which does nothing.

Run: `./run-tests.py --impl "YOUR-COMMAND" 9.1`

| Test | Checks | Expects |
|---|---|---|
| [`value`](01-begin/value.scm) | the value of the last form | output |
| [`order`](01-begin/order.scm) | forms run in order | output (run mode) |
| [`in-if`](01-begin/in-if.scm) | begin inside if | output (run mode) |

---

## 9.2 Procedure bodies

**Spec:** §5.5 lambda, §5.6 define

Implement support for:

- Procedure bodies with several forms, evaluated in order. The value of the last form is the result of the call.

Run: `./run-tests.py --impl "YOUR-COMMAND" 9.2`

| Test | Checks | Expects |
|---|---|---|
| [`value`](02-bodies/value.scm) | the last form gives the result | output |
| [`order`](02-bodies/order.scm) | body forms run in order | output (run mode) |
| [`counter`](02-bodies/counter.scm) | state with set! | output |

---

## 9.3 Internal definitions

**Spec:** §5.6 define, §4.2 Environments and variables

Implement support for:

- `define` at the start of a body, which binds a variable in the environment of that call only.
- Internal definitions that refer to each other, and that shadow globals.

Run: `./run-tests.py --impl "YOUR-COMMAND" 9.3`

| Test | Checks | Expects |
|---|---|---|
| [`local`](03-internal-define/local.scm) | a local definition | output |
| [`mutual-recursion`](03-internal-define/mutual-recursion.scm) | local procedures that call each other | output |
| [`shadows-global`](03-internal-define/shadows-global.scm) | local definitions don't affect globals | output |
| [`per-call`](03-internal-define/per-call.scm) | each call gets its own definitions | output |
| [`counter`](03-internal-define/counter.scm) | a counter with a local variable | output |

---

## 9.4 begin and definitions

**Spec:** §5.8 begin, §5.6 define

Implement support for:

- `begin` creates no new environment. Definitions inside a top-level `begin` are global; definitions inside a `begin` at the start of a body are local to that call.

Run: `./run-tests.py --impl "YOUR-COMMAND" 9.4`

| Test | Checks | Expects |
|---|---|---|
| [`top-level`](04-begin-and-definitions/top-level.scm) | definitions in a top-level begin | output |
| [`in-body`](04-begin-and-definitions/in-body.scm) | definitions in a begin inside a body | output |
| [`not-global`](04-begin-and-definitions/not-global.scm) | definitions in a body's begin don't leak out | error |

---

## 9.5 Interactive programs

**Spec:** §5.8 begin, §9.9 Input and output

**Mode:** run (plain `IMPL FILE...`)

Implement support for:

- Programs that interleave prompts, input, and computed output.

Run: `./run-tests.py --impl "YOUR-COMMAND" 9.5`

| Test | Checks | Expects |
|---|---|---|
| [`prompt`](05-interactive/prompt.scm) | prompts between lines of input | output (stdin) |
| [`sum-numbers`](05-interactive/sum-numbers.scm) | adding up the numbers in the input | output (stdin) |
