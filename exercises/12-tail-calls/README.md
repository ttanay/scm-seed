# Section 12: Tail calls

Scheme has no loop construct; loops are tail calls. Your interpreter must support an unbounded number of active tail calls in bounded space, so these loops of a million iterations must neither overflow nor run out of memory.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §7 Proper tail recursion.

It also contributes to: §9.8 Control (completed in section 15), §9.9 Input and output (completed in section 5).

## Stages

- [ ] [12.1 Self tail calls](#121-self-tail-calls)
- [ ] [12.2 Tail positions](#122-tail-positions)
- [ ] [12.3 Mutual and indirect tail calls](#123-mutual-and-indirect-tail-calls)
- [ ] [12.4 Tail calls through apply and closures](#124-tail-calls-through-apply-and-closures)
- [ ] [12.5 Streaming input](#125-streaming-input)

---

## 12.1 Self tail calls

**Spec:** §7 Proper tail recursion

Implement support for:

- A procedure that calls itself as the last thing it does runs in bounded space, however many times it does so.

> **Note:** These tests run up to a million iterations. If a test times out rather than failing outright, your interpreter may simply be slow; the default per-test timeout is 30 seconds (change it with `--timeout`).

Run: `./run-tests.py --impl "YOUR-COMMAND" 12.1`

| Test | Checks | Expects |
|---|---|---|
| [`count-down`](01-self-tail-calls/count-down.scm) | a loop of one million iterations | output |
| [`count-up`](01-self-tail-calls/count-up.scm) | a loop with an accumulator | output |

---

## 12.2 Tail positions

**Spec:** §7 Proper tail recursion

Implement support for:

- Every tail position in §7: both branches of an `if`, the last form of a `begin`, and the last form of a body, including a body that starts with definitions.

> **Note:** These tests run up to a million iterations. If a test times out rather than failing outright, your interpreter may simply be slow; the default per-test timeout is 30 seconds (change it with `--timeout`).

Run: `./run-tests.py --impl "YOUR-COMMAND" 12.2`

| Test | Checks | Expects |
|---|---|---|
| [`begin`](02-tail-positions/begin.scm) | the last form of a begin | output |
| [`nested-if`](02-tail-positions/nested-if.scm) | branches of nested ifs | output |
| [`after-define`](02-tail-positions/after-define.scm) | a body with an internal definition | output |
| [`multi-form-body`](02-tail-positions/multi-form-body.scm) | the last of several body forms | output |

---

## 12.3 Mutual and indirect tail calls

**Spec:** §7 Proper tail recursion

Implement support for:

- Tail calls to other procedures: mutually recursive procedures, procedures passed as arguments, and procedures that call themselves through a parameter.

> **Note:** These tests run up to a million iterations. If a test times out rather than failing outright, your interpreter may simply be slow; the default per-test timeout is 30 seconds (change it with `--timeout`).

Run: `./run-tests.py --impl "YOUR-COMMAND" 12.3`

| Test | Checks | Expects |
|---|---|---|
| [`mutual`](03-mutual-and-indirect/mutual.scm) | two mutually recursive procedures | output |
| [`state-machine`](03-mutual-and-indirect/state-machine.scm) | three states | output |
| [`through-parameters`](03-mutual-and-indirect/through-parameters.scm) | calling procedures passed as arguments | output |

---

## 12.4 Tail calls through apply and closures

**Spec:** §7 Proper tail recursion, §9.8 Control

Implement support for:

- `apply` calls its procedure as a tail call.
- Loops through local procedures, and long chains of closures that each tail-call the next.

> **Note:** These tests run up to a million iterations. If a test times out rather than failing outright, your interpreter may simply be slow; the default per-test timeout is 30 seconds (change it with `--timeout`).

Run: `./run-tests.py --impl "YOUR-COMMAND" 12.4`

| Test | Checks | Expects |
|---|---|---|
| [`apply`](04-apply-and-closures/apply.scm) | a loop through apply | output |
| [`local-loop`](04-apply-and-closures/local-loop.scm) | a loop through a local procedure | output |
| [`closure-chain`](04-apply-and-closures/closure-chain.scm) | a long chain of closures | output |

---

## 12.5 Streaming input

**Spec:** §7 Proper tail recursion, §9.9 Input and output

Implement support for:

- Programs that process inputs of any size in bounded space.

> **Note:** These tests run up to a million iterations. If a test times out rather than failing outright, your interpreter may simply be slow; the default per-test timeout is 30 seconds (change it with `--timeout`).

Run: `./run-tests.py --impl "YOUR-COMMAND" 12.5`

| Test | Checks | Expects |
|---|---|---|
| [`count`](05-streaming/count.scm) | counting the characters and lines of a large input | output (stdin) |
| [`cat`](05-streaming/cat.scm) | copying a large input | output (stdin, run mode) |
