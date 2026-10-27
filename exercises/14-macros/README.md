# Section 14: Macros

Let programs extend the language's syntax. A macro's transformer is an ordinary Seed procedure that receives the unevaluated operands and returns new code. This is the feature that lets `let`, `cond`, `and`, `or`, and `quasiquote` be written in Seed itself.

**Mode:** `--print` for every test in this section.

## Unlocks

Completing this section **unlocks**: §6 Macros, §9.6 Strings and symbols.

It also contributes to: §5.8 begin (completed in section 9), §7 Proper tail recursion (completed in section 12), §10 Errors (completed in section 13).

## Stages

- [ ] [14.1 define-macro](#141-define-macro)
- [ ] [14.2 Expansion in place](#142-expansion-in-place)
- [ ] [14.3 Rest operands and recursive expansion](#143-rest-operands-and-recursive-expansion)
- [ ] [14.4 Transformers are procedures](#144-transformers-are-procedures)
- [ ] [14.5 Macros and definitions](#145-macros-and-definitions)
- [ ] [14.6 gensym and hygiene](#146-gensym-and-hygiene)
- [ ] [14.7 Macros in tail position](#147-macros-in-tail-position)
- [ ] [14.8 Macro errors](#148-macro-errors)

---

## 14.1 define-macro

**Spec:** §6 Macros

Implement support for:

- `(define-macro (name . formals) body ...)` at top level, which makes `name` a macro. Its value is unspecified.
- A macro use `(name operand ...)` calls the transformer with the operands as unevaluated data, then evaluates the code it returns in place of the use.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.1`

| Test | Checks | Expects |
|---|---|---|
| [`basic`](01-define-macro/basic.scm) | a macro returns code | output |
| [`unevaluated`](01-define-macro/unevaluated.scm) | operands are not evaluated | output |
| [`code-is-evaluated`](01-define-macro/code-is-evaluated.scm) | the expansion is evaluated | output |

---

## 14.2 Expansion in place

**Spec:** §6 Macros

Implement support for:

- The expansion is evaluated in the environment of the macro use, as if it had been written there.
- Macro uses may appear wherever an expression may, including as operands and inside procedure bodies.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.2`

| Test | Checks | Expects |
|---|---|---|
| [`use-environment`](02-expansion/use-environment.scm) | the expansion sees local variables | output |
| [`my-if`](02-expansion/my-if.scm) | only the chosen branch runs | output |
| [`inside-procedures`](02-expansion/inside-procedures.scm) | macros inside procedure bodies | output |

---

## 14.3 Rest operands and recursive expansion

**Spec:** §6 Macros

Implement support for:

- Transformers with rest parameters.
- Expansions that contain further macro uses, of the same macro or another, which are expanded in turn.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.3`

| Test | Checks | Expects |
|---|---|---|
| [`rest-operands`](03-recursive-expansion/rest-operands.scm) | macros with rest parameters | output |
| [`self-recursive`](03-recursive-expansion/self-recursive.scm) | a macro that expands into itself | output |
| [`macro-to-macro`](03-recursive-expansion/macro-to-macro.scm) | a macro that expands into another | output |

---

## 14.4 Transformers are procedures

**Spec:** §6 Macros

Implement support for:

- Transformers can call any procedure defined before the macro is used, and can compute at expansion time.
- Abbreviations such as `` `x `` reach transformers as ordinary lists.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.4`

| Test | Checks | Expects |
|---|---|---|
| [`helpers`](04-transformers/helpers.scm) | a let macro built with helper procedures | output |
| [`compute`](04-transformers/compute.scm) | computing at expansion time | output |
| [`reader-forms`](04-transformers/reader-forms.scm) | abbreviations are lists | output |

---

## 14.5 Macros and definitions

**Spec:** §6 Macros, §5.8 begin

Implement support for:

- Macros that expand into definitions, including several at once through `begin`.
- Macros defined in one file and used in a later one, and redefining a macro.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.5`

| Test | Checks | Expects |
|---|---|---|
| [`several`](05-definitions/several.scm) | a macro that defines two variables | output |
| [`across-files`](05-definitions/across-files.scm) | a macro from an earlier file | output (several files) |
| [`redefinition`](05-definitions/redefinition.scm) | redefining a macro | output |

---

## 14.6 gensym and hygiene

**Spec:** §9.6 Strings and symbols, §6 Macros

Implement support for:

- The primitive `gensym`, which returns a new symbol that is not `eq?` to any other symbol, including any symbol later made from its name.
- Using `gensym` so that a macro's own variables cannot capture the user's.

> **Note:** Symbols from `gensym` have implementation-defined names, so no test prints one.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.6`

| Test | Checks | Expects |
|---|---|---|
| [`fresh`](06-gensym/fresh.scm) | gensym makes fresh symbols | output |
| [`swap`](06-gensym/swap.scm) | a swap macro that doesn't capture variables | output |

---

## 14.7 Macros in tail position

**Spec:** §6 Macros, §7 Proper tail recursion

Implement support for:

- A macro use in tail position stays in tail position: its expansion runs as a tail call.

> **Note:** This test runs a million iterations.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.7`

| Test | Checks | Expects |
|---|---|---|
| [`loop`](07-tail-position/loop.scm) | a loop through a macro | output |

---

## 14.8 Macro errors

**Spec:** §6 Macros, §10 Errors

Implement support for:

- Signaling an error for a macro used with the wrong number of operands, for a transformer that signals an error, for a malformed `define-macro`, and for `gensym` with arguments.

Run: `./run-tests.py --impl "YOUR-COMMAND" 14.8`

| Test | Checks | Expects |
|---|---|---|
| [`transformer-arity`](08-macro-errors/transformer-arity.scm) | the wrong number of operands | error |
| [`transformer-error`](08-macro-errors/transformer-error.scm) | a transformer that signals an error | error |
| [`malformed`](08-macro-errors/malformed.scm) | (define-macro m 1) | error |
| [`gensym-arity`](08-macro-errors/gensym-arity.scm) | (gensym 1) | error |
