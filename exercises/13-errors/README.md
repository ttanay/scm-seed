# Section 13: Errors

Every section so far has required signaling some errors. This one adds `error`, which lets programs signal their own, and pins down exactly what happens when an error is signaled.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §4.5 Process interface, §10 Errors.

It also contributes to: §9.8 Control (completed in section 15).

## Stages

- [ ] [13.1 The error procedure](#131-the-error-procedure)
- [ ] [13.2 Where errors stop](#132-where-errors-stop)
- [ ] [13.3 Errors in run mode](#133-errors-in-run-mode)

---

## 13.1 The error procedure

**Spec:** §9.8 Control, §10 Errors

Implement support for:

- The primitive `error`, which takes a message and any number of further arguments (irritants) and signals an error.
- `error` is an ordinary procedure: it can be stored, passed, and applied.

Run: `./run-tests.py --impl "YOUR-COMMAND" 13.1`

| Test | Checks | Expects |
|---|---|---|
| [`basic`](01-error-procedure/basic.scm) | error stops the program | error |
| [`irritants`](01-error-procedure/irritants.scm) | error with irritants | error |
| [`non-string`](01-error-procedure/non-string.scm) | a non-string message | error |
| [`as-value`](01-error-procedure/as-value.scm) | error passed as a value | error |
| [`applied`](01-error-procedure/applied.scm) | error called through apply | error |

---

## 13.2 Where errors stop

**Spec:** §10 Errors, §4.5 Process interface

Implement support for:

- A signaled error stops the whole program at once: no further forms and no further files are evaluated, however deep inside procedure calls the error happens.
- A procedure whose body would signal an error signals it only when called.

Run: `./run-tests.py --impl "YOUR-COMMAND" 13.2`

| Test | Checks | Expects |
|---|---|---|
| [`deep`](02-where-errors-stop/deep.scm) | an error deep inside recursion | error |
| [`deferred`](02-where-errors-stop/deferred.scm) | an error in a body happens when the procedure is called | error |
| [`later-files`](02-where-errors-stop/later-files.scm) | an error stops later files | error (several files) |

---

## 13.3 Errors in run mode

**Spec:** §10 Errors, §4.5 Process interface

**Mode:** run (plain `IMPL FILE...`)

Implement support for:

- In run mode, every character written before an error must reach standard output, however much output there was.

Run: `./run-tests.py --impl "YOUR-COMMAND" 13.3`

| Test | Checks | Expects |
|---|---|---|
| [`flush`](03-run-mode-errors/flush.scm) | a lot of output, then an error | error |
| [`partial-line`](03-run-mode-errors/partial-line.scm) | an error in the middle of a line | error |
| [`read-error`](03-run-mode-errors/read-error.scm) | a read error in run mode | error |
