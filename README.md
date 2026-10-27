# Seed 🌱 — the Maxwell's Equations of Scheme

> "…when I finally understood that the half page of code on the bottom of page 13 of the Lisp 1.5 manual was Lisp in itself. These were 'Maxwell's Equations of Software!'"
> — Alan Kay, [*A Conversation with Alan Kay*](https://queue.acm.org/detail.cfm?id=1039523), ACM Queue, 2004

**Seed** is a minimal dialect of Scheme you can implement yourself. It has **7 special forms and 38 primitives**: enough to bootstrap a full Scheme standard library *in Scheme itself*, and small enough that the interpreter is a weekend project.

The repo holds a language specification. Bring your own interpreter, in any language. Make it conform to [`spec.md`](spec.md), then grow the rest of Scheme from the seed.

---

## Why?

Most "write a Lisp" tutorials stop at a toy that can't run real programs. Full R7RS has hundreds of procedures and syntactic forms, which is a lot to implement natively before you can write anything interesting.

Seed sits between the two:

- **Small core.** Only things that *can't* be derived (or can only be derived far too slowly) are built in.
- **Real semantics.** Proper tail calls, first-class re-entrant continuations, macros, and lexical closures are all included. None of the hard parts are skipped.
- **The library is the second half of the exercise.** `let`, `cond`, `quasiquote`, variadic `+`, `map`, `display`, `dynamic-wind`, exceptions, and even `read` and `syntax-rules` are written *in Seed*, running on *your* interpreter.

## The whole language at a glance

```
Special forms (7):  quote  if  lambda  define  set!  begin  define-macro

Primitives (38):
  pairs       cons car cdr set-car! set-cdr!
  types       pair? symbol? number? char? string? vector? procedure? eof-object?
  identity    eq?
  integers    + - * quotient remainder = <          ; all binary
  chars       char->integer integer->char
  strings     string->list list->string symbol->string string->symbol gensym
  vectors     make-vector vector-length vector-ref vector-set!
  control     apply call/cc error
  i/o         read-char peek-char write-char
```

Required semantics:

- lexical scope;
- `#f` is the only false value;
- exact integers;
- **proper tail recursion**;
- **re-entrant `call/cc`**;
- non-hygienic `define-macro`;
- primitives are ordinary, redefinable global variables.

Everything else is library. See [`spec.md`](spec.md) for the full specification.

### What's deliberately missing (and where it comes from)

| Not in the core | Built in the library from |
|---|---|
| `let`, `let*`, `letrec`, `cond`, `case`, `and`, `or`, `when`, `unless`, `do` | `define-macro` + `lambda` + `if` |
| `quasiquote` | The reader produces `(quasiquote …)`; a macro expands it |
| Variadic `+ - * < =`, `>`, `<=`, `abs`, `gcd`, `expt`, `modulo` | Folds over the binary primitives |
| `list`, `length`, `append`, `reverse`, `map`, `assoc`, `member`, … | Plain recursion |
| `string-length`, `string-append`, `substring`, `string=?`, … | `string->list` / `list->string` |
| `display`, `write`, `newline` | `write-char` |
| `read` | `read-char` + `peek-char` (Seed reading Seed!) |
| `eqv?`, `equal?` | `eq?` + `=` + type predicates |
| `dynamic-wind`, `values`, exceptions, generators | `call/cc` + closures |
| `define-record-type` | `define-macro` + `begin` + vectors |
| `syntax-rules` | A pattern matcher written as a `define-macro` transformer |
| Bignums, rationals | Integer arithmetic in Seed |
| `eval` | A metacircular evaluator in Seed |

Floating point, files, and clocks are left to optional implementation extensions.

## How to use this repo

### 1. Implement the core

Write an interpreter in whatever language you like. The only contract is the **process interface** ([spec §4.5](spec.md#45-process-interface)):

```sh
your-seed FILE...        # evaluate files in order, in one global environment
```

| Channel | Meaning |
|---|---|
| stdout | Exactly the characters written by `write-char`. |
| stdin  | Read only by `read-char` / `peek-char`. |
| stderr | Diagnostics. |
| exit `0` | Success. |
| exit non-zero | A signaled error. |

This makes every implementation interchangeable. The same test programs and the same library run on all of them.

### 2. Grow the library

Write your standard library as Seed files and load them ahead of your program:

```sh
your-seed lib/00-base.scm lib/10-syntax.scm lib/20-lists.scm lib/30-io.scm my-program.scm
```

[Appendix B of the spec](spec.md#appendix-b-bootstrapping-examples-informative) shows the first steps: `list`, `let`, `and`/`or`/`cond`, `quasiquote`, variadic `+`, and a number printer.

### Suggested milestones

**Interpreter**

1. **Reader.** Datums, quote abbreviations, comments ([§2](spec.md#2-lexical-syntax)). Write a debug printer in your host language too; you'll need it.
2. **Eval/apply.** Self-evaluating atoms, variables, `quote`, `if`, `lambda`, `define`, `set!`, `begin`, and the primitives.
3. **Proper tail calls.** `(loop 1000000)` must not blow the stack ([§7](spec.md#7-proper-tail-recursion)). Typical approaches are a trampoline, an explicit stack, or CPS.
4. **Macros.** `define-macro` and `gensym` ([§6](spec.md#6-macros)).
5. **Continuations.** First escape-only, then fully re-entrant `call/cc` ([§8](spec.md#8-continuations)). If you did CPS or an explicit stack in step 3, this part is easy.
6. **Errors and exit codes.** [§10](spec.md#10-errors).

**Library**

1. List basics: `list`, `null?`, `not`, `cadr`, `map`, `append`.
2. Syntax: `let`, `and`, `or`, `cond`, `let*`, `letrec`, named `let`, `when`, `unless`, `quasiquote`.
3. Numbers: variadic arithmetic, comparisons, `number->string`.
4. Output: `display`, `write`, `newline`.
5. Equality: `eqv?`, `equal?`; then `member`, `assoc`.
6. Strings and characters.
7. Control: `dynamic-wind`, `values`, `raise`/`guard`.
8. Stretch goals: `read` in Seed, `syntax-rules`, bignums, a metacircular `eval`.

## Repository layout

```
README.md   – this file
spec.md     – the language specification (normative)
```

A shared conformance test suite and a reference library are planned. The examples in [spec Appendix C](spec.md#appendix-c-conformance-examples) are a good starting point for your own tests, and contributions are welcome (see below).

## Contributing

- **Spec issues.** If something is ambiguous, contradictory, or under-specified, please open an issue that quotes the section number.
- **Tests.** Small programs paired with their expected stdout and exit status are the most useful kind of contribution.
- **Implementations.** Link yours in an issue or PR and we'll add it to a list here.

Proposals to *add* something to the core need to show that it can't reasonably be derived in Seed. That rule is the whole point of the project.

## Further reading

- J. McCarthy et al., [*LISP 1.5 Programmer's Manual*](https://www.softwarepreservation.org/projects/LISP/book/LISP%201.5%20Programmers%20Manual.pdf) (1962). The original "Maxwell's equations" are on p. 13.
- P. Graham, [*The Roots of Lisp*](https://paulgraham.com/rootsoflisp.html) (2002).
- Abelson & Sussman, [*Structure and Interpretation of Computer Programs*](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html), ch. 4–5.
- [R7RS-small](https://small.r7rs.org/attachment/r7rs.pdf). The standard Seed bootstraps toward.
- C. Queinnec, *Lisp in Small Pieces* (1996).
- R. K. Dybvig, [*The Scheme Programming Language*](https://www.scheme.com/tspl4/), 4th ed.

The spec's [References](spec.md#references) section has the full bibliography.

## License

_TBD. Add a `LICENSE` file before publishing. MIT or CC-BY-4.0 are common choices for specifications._
