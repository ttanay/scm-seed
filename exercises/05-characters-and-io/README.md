# Section 5: Characters and I/O

Until now the harness printed values for you. Real Seed programs produce output only through `write-char`, and read input only through `read-char` and `peek-char`. This section adds run mode, `IMPL FILE...`, where standard output contains exactly what the program writes, and nothing else.

**Mode:** run (plain `IMPL FILE...`), unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §9.9 Input and output.

It also contributes to: §3.1 Disjoint types (completed in section 11), §4.1 Programs (completed in section 7), §4.5 Process interface (completed in section 13), §9.2 Type predicates (completed in section 11), §10 Errors (completed in section 13).

## Stages

- [ ] [5.1 Writing characters](#51-writing-characters)
- [ ] [5.2 Run mode](#52-run-mode)
- [ ] [5.3 Reading characters](#53-reading-characters)
- [ ] [5.4 peek-char and end of input](#54-peek-char-and-end-of-input)
- [ ] [5.5 Runtime errors: I/O](#55-runtime-errors-io)

---

## 5.1 Writing characters

**Spec:** §9.9 Input and output, §4.5 Process interface

Implement support for:

- Run mode: `IMPL FILE...` evaluates each form and prints nothing on its own.
- The primitive `write-char`, which writes one character to standard output.

Run: `./run-tests.py --impl "YOUR-COMMAND" 5.1`

| Test | Checks | Expects |
|---|---|---|
| [`hello`](01-write-char/hello.scm) | Hello, world | output |
| [`named-chars`](01-write-char/named-chars.scm) | space, tab, and newline | output |
| [`delimiter-chars`](01-write-char/delimiter-chars.scm) | characters that are delimiters or prefixes | output |
| [`computed`](01-write-char/computed.scm) | writing computed characters | output |

---

## 5.2 Run mode

**Spec:** §4.1 Programs, §4.5 Process interface

Implement support for:

- In run mode, values of top-level forms are not printed. Only `write-char` produces output.
- Several files run in order, as one program.

Run: `./run-tests.py --impl "YOUR-COMMAND" 5.2`

| Test | Checks | Expects |
|---|---|---|
| [`silent-values`](02-run-mode/silent-values.scm) | values are not printed | output |
| [`several-files`](02-run-mode/several-files.scm) | files run in order | output (several files) |
| [`empty`](02-run-mode/empty.scm) | a program that writes nothing | no output |

---

## 5.3 Reading characters

**Spec:** §9.9 Input and output, §4.5 Process interface

Implement support for:

- The primitive `read-char`, which removes the next character from standard input and returns it.

Run: `./run-tests.py --impl "YOUR-COMMAND" 5.3`

| Test | Checks | Expects |
|---|---|---|
| [`echo-fixed`](03-read-char/echo-fixed.scm) | copying input to output | output (stdin) |
| [`whitespace`](03-read-char/whitespace.scm) | whitespace characters are read too | output (stdin) |
| [`caesar`](03-read-char/caesar.scm) | shifting letters | output (stdin) |
| [`upcase`](03-read-char/upcase.scm) | upper-casing letters | output (stdin) |
| [`digit-sum`](03-read-char/digit-sum.scm) | reading digits as numbers | output (stdin) |

---

## 5.4 peek-char and end of input

**Spec:** §9.9 Input and output, §9.2 Type predicates, §3.1 Disjoint types

**Mode:** `--print`

Implement support for:

- The primitive `peek-char`, which returns the next character without removing it.
- A distinct eof object, returned by `read-char` and `peek-char` at end of input, every time they are asked. In `--print` mode it prints as `#<eof>`.
- The predicate `eof-object?`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 5.4`

| Test | Checks | Expects |
|---|---|---|
| [`read-values`](04-peek-and-eof/read-values.scm) | read-char returns characters, then eof | output (stdin) |
| [`eof-repeats`](04-peek-and-eof/eof-repeats.scm) | end of input is reported every time | output |
| [`peek`](04-peek-and-eof/peek.scm) | peek-char does not consume input | output (stdin) |
| [`eof-predicate`](04-peek-and-eof/eof-predicate.scm) | eof-object? and the disjointness of the eof object | output (stdin) |
| [`whitespace`](04-peek-and-eof/whitespace.scm) | whitespace input | output (stdin) |

---

## 5.5 Runtime errors: I/O

**Spec:** §9.9 Input and output, §10 Errors

Implement support for:

- Signaling an error for `write-char` of a non-character, and for the wrong number of arguments to the I/O primitives.
- In run mode too, output written before an error must appear.

Run: `./run-tests.py --impl "YOUR-COMMAND" 5.5`

| Test | Checks | Expects |
|---|---|---|
| [`write-integer`](05-io-errors/write-integer.scm) | (write-char 65) | error |
| [`write-string`](05-io-errors/write-string.scm) | (write-char "a") | error |
| [`write-none`](05-io-errors/write-none.scm) | (write-char) | error |
| [`write-two`](05-io-errors/write-two.scm) | (write-char #\a #\b) | error |
| [`read-arity`](05-io-errors/read-arity.scm) | (read-char 1) | error |
| [`peek-arity`](05-io-errors/peek-arity.scm) | (peek-char 1) | error |
| [`eof-arity`](05-io-errors/eof-arity.scm) | (eof-object?) | error (print mode) |
