# Section 7: Variables

Give values names. Top-level definitions live in the global environment, alongside the primitives, and can be changed with `set!`.

**Mode:** `--print`, unless a stage or test says otherwise.

## Unlocks

Completing this section **unlocks**: §4.1 Programs, §5.1 Variable reference, §5.7 set!.

It also contributes to: §4.2 Environments and variables (completed in section 8), §5.6 define (completed in section 9), §9.3 Identity (completed in section 4), §9.9 Input and output (completed in section 5), §10 Errors (completed in section 13).

## Stages

- [ ] [7.1 define](#71-define)
- [ ] [7.2 Redefinition and order](#72-redefinition-and-order)
- [ ] [7.3 set!](#73-set!)
- [ ] [7.4 Primitives are variables](#74-primitives-are-variables)
- [ ] [7.5 Identity through variables](#75-identity-through-variables)
- [ ] [7.6 Remembering input](#76-remembering-input)
- [ ] [7.7 Runtime errors: variables](#77-runtime-errors-variables)

---

## 7.1 define

**Spec:** §5.6 define, §4.2 Environments and variables

Implement support for:

- `(define variable expression)` at top level: evaluate `expression` and bind `variable` to the result in the global environment.
- The value of a `define` form is unspecified, so `--print` mode prints nothing for it.

Run: `./run-tests.py --impl "YOUR-COMMAND" 7.1`

| Test | Checks | Expects |
|---|---|---|
| [`define`](01-define/define.scm) | defining and using variables | output |
| [`prints-nothing`](01-define/prints-nothing.scm) | a define on its own prints nothing | no output |
| [`procedure-value`](01-define/procedure-value.scm) | a variable holding a primitive | output |

---

## 7.2 Redefinition and order

**Spec:** §5.6 define, §4.1 Programs

Implement support for:

- Redefining a variable that already exists replaces its value.
- Forms are evaluated in order, so a variable holds the value of the most recent definition.
- Definitions made in one file are visible in later files.

Run: `./run-tests.py --impl "YOUR-COMMAND" 7.2`

| Test | Checks | Expects |
|---|---|---|
| [`redefine`](02-redefinition/redefine.scm) | the latest definition wins | output |
| [`values-not-references`](02-redefinition/values-not-references.scm) | a variable holds a value, not another variable | output |
| [`across-files`](02-redefinition/across-files.scm) | definitions are shared between files | output (several files) |

---

## 7.3 set!

**Spec:** §5.7 set!

Implement support for:

- `(set! variable expression)`: store a new value in an existing variable. Its value is unspecified.

Run: `./run-tests.py --impl "YOUR-COMMAND" 7.3`

| Test | Checks | Expects |
|---|---|---|
| [`set`](03-set/set.scm) | changing a variable | output |
| [`prints-nothing`](03-set/prints-nothing.scm) | set! on its own prints nothing | no output |
| [`copy-unaffected`](03-set/copy-unaffected.scm) | set! changes one variable only | output |

---

## 7.4 Primitives are variables

**Spec:** §4.2 Environments and variables, §5.7 set!

Implement support for:

- The primitives are ordinary global variables. They can be copied into other variables, redefined, and restored.

Run: `./run-tests.py --impl "YOUR-COMMAND" 7.4`

| Test | Checks | Expects |
|---|---|---|
| [`alias`](04-primitives-are-variables/alias.scm) | copying a primitive | output |
| [`redefine`](04-primitives-are-variables/redefine.scm) | redefining and restoring a primitive | output |
| [`set-primitive`](04-primitives-are-variables/set-primitive.scm) | set! on a primitive | output |

---

## 7.5 Identity through variables

**Spec:** §9.3 Identity, §5.1 Variable reference

Implement support for:

- A variable refers to an object; two variables may refer to the same one.

Run: `./run-tests.py --impl "YOUR-COMMAND" 7.5`

| Test | Checks | Expects |
|---|---|---|
| [`same-object`](05-identity/same-object.scm) | eq? through variables | output |
| [`symbols`](05-identity/symbols.scm) | a variable holding a symbol | output |

---

## 7.6 Remembering input

**Spec:** §5.6 define, §9.9 Input and output

**Mode:** run (plain `IMPL FILE...`)

Implement support for:

- Storing what a program reads in variables, so it can be used later.

Run: `./run-tests.py --impl "YOUR-COMMAND" 7.6`

| Test | Checks | Expects |
|---|---|---|
| [`reverse-three`](06-remembering-input/reverse-three.scm) | reading three characters and writing them backwards | output (stdin) |
| [`compare`](06-remembering-input/compare.scm) | comparing two characters | output (stdin) |

---

## 7.7 Runtime errors: variables

**Spec:** §5.1 Variable reference, §5.6 define, §5.7 set!, §10 Errors

Implement support for:

- Signaling an error for `set!` of an unbound variable, and for malformed `define` and `set!` forms.

Run: `./run-tests.py --impl "YOUR-COMMAND" 7.7`

| Test | Checks | Expects |
|---|---|---|
| [`set-unbound`](07-variable-errors/set-unbound.scm) | set! of an unbound variable | error |
| [`define-non-symbol`](07-variable-errors/define-non-symbol.scm) | (define 1 2) | error |
| [`define-too-many`](07-variable-errors/define-too-many.scm) | (define x 1 2) | error |
| [`define-empty`](07-variable-errors/define-empty.scm) | (define) | error |
| [`define-no-value`](07-variable-errors/define-no-value.scm) | (define x) | error |
| [`set-non-symbol`](07-variable-errors/set-non-symbol.scm) | (set! 1 2) | error |
| [`set-no-value`](07-variable-errors/set-no-value.scm) | (set! x) | error |
