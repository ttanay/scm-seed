# Section 2: Evaluating data

Now forms are evaluated. In `--print` mode, your interpreter evaluates each top-level form and prints its value. This section covers the forms that need no procedure calls: data that evaluates to itself, `quote`, and variable references.

**Mode:** `--print` for every test in this section.

## Unlocks

Completing this section **unlocks**: §5.3 quote.

It also contributes to: §3.1 Disjoint types (completed in section 11), §4.1 Programs (completed in section 7), §4.2 Environments and variables (completed in section 8), §5.1 Variable reference (completed in section 7), §10 Errors (completed in section 13).

## Stages

- [ ] [2.1 Self-evaluating data](#21-self-evaluating-data)
- [ ] [2.2 quote](#22-quote)
- [ ] [2.3 Variables](#23-variables)
- [ ] [2.4 Malformed quote](#24-malformed-quote)

---

## 2.1 Self-evaluating data

**Spec:** §3.1 Disjoint types, §4.1 Programs

Implement support for:

- Running `IMPL --print FILE...`: evaluate each top-level form in order and print its value in the standard output format.
- Integers, booleans, characters, and strings evaluate to themselves.

Run: `./run-tests.py --impl "YOUR-COMMAND" 2.1`

| Test | Checks | Expects |
|---|---|---|
| [`integers`](01-self-evaluating/integers.scm) | integers | output |
| [`booleans`](01-self-evaluating/booleans.scm) | booleans | output |
| [`characters`](01-self-evaluating/characters.scm) | characters | output |
| [`strings`](01-self-evaluating/strings.scm) | strings | output |
| [`several-files`](01-self-evaluating/several-files.scm) | forms from several files, in order | output (several files) |

---

## 2.2 quote

**Spec:** §5.3 quote

Implement support for:

- The special form `quote`, written out or as `'`. It returns its datum without evaluating it.

Run: `./run-tests.py --impl "YOUR-COMMAND" 2.2`

| Test | Checks | Expects |
|---|---|---|
| [`symbols`](02-quote/symbols.scm) | quoted symbols | output |
| [`lists`](02-quote/lists.scm) | quoted lists | output |
| [`nested`](02-quote/nested.scm) | quoting a quote | output |
| [`not-evaluated`](02-quote/not-evaluated.scm) | the datum is not evaluated | output |
| [`self-evaluating`](02-quote/self-evaluating.scm) | quoting self-evaluating data | output |

---

## 2.3 Variables

**Spec:** §4.2 Environments and variables, §5.1 Variable reference, §10 Errors

Implement support for:

- Variable references: a symbol evaluates to the value bound to it in the global environment.
- The global environment starts out holding the primitive procedures. In `--print` mode, a procedure prints as `#<procedure>`.
- Signaling an error for a reference to an unbound variable. Output already printed must still appear on standard output.

Run: `./run-tests.py --impl "YOUR-COMMAND" 2.3`

| Test | Checks | Expects |
|---|---|---|
| [`primitives`](03-variables/primitives.scm) | primitives are values | output |
| [`quoted`](03-variables/quoted.scm) | a quoted symbol is not a variable reference | output |
| [`unbound`](03-variables/unbound.scm) | an unbound variable | error |
| [`case-sensitive`](03-variables/case-sensitive.scm) | variable names are case-sensitive | error |

---

## 2.4 Malformed quote

**Spec:** §5.3 quote, §10 Errors

Implement support for:

- Signaling an error for a `quote` form with no datum or with more than one.

Run: `./run-tests.py --impl "YOUR-COMMAND" 2.4`

| Test | Checks | Expects |
|---|---|---|
| [`no-datum`](04-quote-errors/no-datum.scm) | (quote) | error |
| [`two-data`](04-quote-errors/two-data.scm) | (quote 1 2) | error |
| [`improper`](04-quote-errors/improper.scm) | (quote . 1) | error |
