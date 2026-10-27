# Section 10: Strings and symbols

Strings have been readable since section 1. This section adds the primitives that convert them to lists of characters and to symbols, which is enough to derive every other string operation in Seed itself.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §3.4 Characters and strings.

It also contributes to: §9.3 Identity (completed in section 4), §9.6 Strings and symbols (completed in section 14), §9.9 Input and output (completed in section 5), §10 Errors (completed in section 13).

## Stages

- [ ] [10.1 Strings and lists](#101-strings-and-lists)
- [ ] [10.2 Strings and symbols](#102-strings-and-symbols)
- [ ] [10.3 String identity](#103-string-identity)
- [ ] [10.4 Strings in programs](#104-strings-in-programs)
- [ ] [10.5 Runtime errors: strings](#105-runtime-errors-strings)

---

## 10.1 Strings and lists

**Spec:** §9.6 Strings and symbols, §3.4 Characters and strings

Implement support for:

- The primitives `string->list` and `list->string`, which convert between a string and a new list of its characters.

Run: `./run-tests.py --impl "YOUR-COMMAND" 10.1`

| Test | Checks | Expects |
|---|---|---|
| [`string-to-list`](01-string-conversion/string-to-list.scm) | string->list | output |
| [`list-to-string`](01-string-conversion/list-to-string.scm) | list->string | output |
| [`derived`](01-string-conversion/derived.scm) | string operations derived from lists | output |

---

## 10.2 Strings and symbols

**Spec:** §9.6 Strings and symbols

Implement support for:

- The primitives `symbol->string`, which returns a symbol's name, and `string->symbol`, which returns the interned symbol with a given name.

Run: `./run-tests.py --impl "YOUR-COMMAND" 10.2`

| Test | Checks | Expects |
|---|---|---|
| [`symbol-to-string`](02-symbols/symbol-to-string.scm) | symbol->string preserves case | output |
| [`string-to-symbol`](02-symbols/string-to-symbol.scm) | string->symbol interns | output |
| [`round-trip`](02-symbols/round-trip.scm) | converting back and forth | output |

---

## 10.3 String identity

**Spec:** §9.3 Identity, §3.4 Characters and strings

Implement support for:

- Strings are objects: `eq?` compares them by identity, and each conversion makes a new string.

Run: `./run-tests.py --impl "YOUR-COMMAND" 10.3`

| Test | Checks | Expects |
|---|---|---|
| [`identity`](03-string-identity/identity.scm) | eq? on strings | output |

---

## 10.4 Strings in programs

**Spec:** §9.6 Strings and symbols, §9.9 Input and output

**Mode:** run (plain `IMPL FILE...`)

Implement support for:

- Programs that write messages from string literals, and that turn input into strings and symbols.

Run: `./run-tests.py --impl "YOUR-COMMAND" 10.4`

| Test | Checks | Expects |
|---|---|---|
| [`hello`](04-strings-in-programs/hello.scm) | writing a string | output |
| [`greeting`](04-strings-in-programs/greeting.scm) | a reply built from input | output (stdin) |
| [`read-word`](04-strings-in-programs/read-word.scm) | turning input into symbols | output (stdin) |

---

## 10.5 Runtime errors: strings

**Spec:** §9.6 Strings and symbols, §10 Errors

Implement support for:

- Signaling an error for arguments of the wrong type, for `list->string` of an improper list or of a list containing non-characters, and for wrong arities.

Run: `./run-tests.py --impl "YOUR-COMMAND" 10.5`

| Test | Checks | Expects |
|---|---|---|
| [`list-to-string-type`](05-string-errors/list-to-string-type.scm) | list->string of integers | error |
| [`list-to-string-improper`](05-string-errors/list-to-string-improper.scm) | list->string of an improper list | error |
| [`string-to-list-type`](05-string-errors/string-to-list-type.scm) | string->list of a symbol | error |
| [`symbol-to-string-type`](05-string-errors/symbol-to-string-type.scm) | symbol->string of a string | error |
| [`string-to-symbol-type`](05-string-errors/string-to-symbol-type.scm) | string->symbol of a symbol | error |
| [`arity`](05-string-errors/arity.scm) | string->list with two arguments | error |
