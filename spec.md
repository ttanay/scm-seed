# The Seed Language Specification

**Version 0.1 (draft) — 2026-10-27**

Seed is a minimal dialect of Scheme. The core is small enough to build in a weekend, yet expressive enough that the rest of a practical Scheme (derived syntax, list library, string library, numeric tower above integers, `dynamic-wind`, exceptions, generators, even `syntax-rules`) can be written *in Seed itself*.

This document is normative unless a section is marked *informative*.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Lexical Syntax](#2-lexical-syntax)
3. [Data Types](#3-data-types)
4. [Programs and Execution Model](#4-programs-and-execution-model)
5. [Expressions (Special Forms)](#5-expressions-special-forms)
6. [Macros](#6-macros)
7. [Proper Tail Recursion](#7-proper-tail-recursion)
8. [Continuations](#8-continuations)
9. [Primitive Procedures](#9-primitive-procedures)
10. [Errors](#10-errors)
11. [Conformance](#11-conformance)
12. [Rationale (informative)](#12-rationale-informative)
- [Appendix A: Reference Evaluator (informative)](#appendix-a-reference-evaluator-informative)
- [Appendix B: Bootstrapping Examples (informative)](#appendix-b-bootstrapping-examples-informative)
- [Appendix C: Conformance Examples](#appendix-c-conformance-examples)
- [References](#references)

---

## 1. Introduction

### 1.1 Goals

1. **Minimal.** Every special form and primitive has to justify its place: either nothing else in the core can express it, or deriving it would make it asymptotically slower (see §12.2).
2. **Complete.** A conforming implementation plus a library written in Seed should be able to provide the bulk of R7RS-small [R7RS]: everything except features that need host facilities Seed leaves out on purpose (floating point, files, the system clock, and so on).
3. **Scheme.** Seed keeps what makes Scheme Scheme: lexical scope, first-class procedures, proper tail recursion, and first-class continuations [R7RS §1.1, Sussman & Steele 1975].
4. **Pluggable.** The process interface (§4.5) is fixed, so the same test programs and libraries work with any implementation.

### 1.2 Non-goals

- Seed does not try to be convenient to program in directly. Before the library is written it is about as pleasant as assembly.
- Seed does not specify a REPL, a printer, or a module system. An implementation may provide them as extensions (§11.3).

### 1.3 Notation and terminology

- **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** are used as defined in [RFC 2119].
- `expr ⇒ value` means that evaluating `expr` returns `value`.
- **"signals an error"**: the implementation MUST detect the condition and terminate the program as described in §10.
- **"it is an error"**: the program is incorrect. The implementation is *not* required to detect it, and the behavior is undefined. Conforming programs MUST NOT do it. (This is R7RS's distinction, [R7RS §1.3.2].)
- **"unspecified"**: the value or behavior can be anything, but it is not an error. Conforming programs MUST NOT depend on it.
- In procedure signatures, `obj` is any object, `k` is an integer, `char` is a character, `str` is a string, `sym` is a symbol, `pair` is a pair, `list` is a proper list, `vec` is a vector, and `proc` is a procedure.

---

## 2. Lexical Syntax

The reader turns program text into data (*datums*). Seed programs are datums, so the reader *is* the parser [McCarthy 1960].

### 2.1 Formal grammar

```ebnf
program      = { atmosphere } , { datum , { atmosphere } } ;

datum        = boolean | integer | character | string | symbol
             | list | abbreviation ;

list         = "(" , { atmosphere } , { datum , { atmosphere } } , ")"
             | "(" , { atmosphere } , datum , { atmosphere } ,
                     { datum , { atmosphere } } ,
                     "." , { atmosphere } , datum , { atmosphere } , ")" ;

abbreviation = ( "'" | "`" | "," | ",@" ) , { atmosphere } , datum ;

boolean      = "#t" | "#f" ;
integer      = [ "+" | "-" ] , digit , { digit } ;
character    = "#\" , any-char
             | "#\space" | "#\newline" | "#\tab" ;
string       = '"' , { string-char | escape } , '"' ;
escape       = "\\" | '\"' | "\n" | "\t" ;
symbol       = symbol-char , { symbol-char } ;   (* see 2.3 *)

atmosphere   = whitespace | comment ;
whitespace   = " " | TAB | LF | CR | FF ;
comment      = ";" , { any char except LF } , ( LF | end-of-input ) ;
digit        = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
```

### 2.2 Delimiters

A *delimiter* is whitespace, `(`, `)`, `"`, `;`, or end of input. Integers, booleans, characters, and symbols MUST be followed by a delimiter. A token keeps going until the next delimiter. Compare [R7RS §7.1.1].

### 2.3 Tokens

- **Integers.** An optional sign followed by one or more decimal digits (`42`, `-7`, `+3`). A token that does not match the `integer` rule is a symbol, so `+`, `-`, `1+`, and `-x` are all symbols.
- **Booleans.** `#t` and `#f`. Implementations MAY also accept `#true` and `#false`.
- **Characters.** `#\` followed by one character, such as `#\a`, `#\(`, or `#\ ` (a space). If more non-delimiter characters follow the first one, the whole token is a *character name*. Implementations MUST recognize `space` (U+0020), `newline` (U+000A), and `tab` (U+0009). Implementations MAY support more names and `#\xHH` hex escapes. A character name the implementation does not support signals an error.
- **Strings.** Text between double quotes. Implementations MUST support the escapes `\\`, `\"`, `\n` (U+000A), and `\t` (U+0009). An escape the implementation does not support signals an error, and so does a string that is not closed before end of input. A string literal MAY span lines; the newlines are part of the string.
- **Symbols.** Any other token made of non-delimiter characters, except that a symbol MUST NOT start with `#` or with one of `'` `` ` `` `,`. Symbols are **case-sensitive**: `Foo` and `foo` are different symbols [R7RS §2.1].
- **Dot.** A token that is exactly `.` is only valid in the dotted position of a list, with exactly one datum after it. Anywhere else it signals an error.
- **Other `#` syntax.** A token starting with `#` that is not a boolean, a character, or an extension the implementation supports (§2.5) signals an error.
- **Parentheses.** An unmatched `(` or `)` signals an error.

### 2.4 Abbreviations

The reader expands these prefixes [R7RS §4.2.8, Bawden 1999]:

| Text        | Read as                       |
|-------------|-------------------------------|
| `'d`        | `(quote d)`                   |
| `` `d ``    | `(quasiquote d)`              |
| `,d`        | `(unquote d)`                 |
| `,@d`       | `(unquote-splicing d)`        |

Only `quote` is a special form in the core. `quasiquote` is read by the core and *implemented by the library* as a macro (Appendix B.4).

### 2.5 Not in the core reader

Vector literals `#(...)`, block comments `#| ... |#`, datum comments `#;`, non-decimal number prefixes, and non-integer numbers are not part of the core. Implementations MAY support them as extensions. Conforming programs MUST NOT use them.

---

## 3. Data Types

### 3.1 Disjoint types

Every Seed object belongs to exactly one of these types [R7RS §3.2]:

| Type          | Predicate       | Literal syntax         | Notes |
|---------------|-----------------|------------------------|-------|
| boolean       | *(derived)*     | `#t` `#f`              | Exactly two objects. |
| integer       | `number?`       | `42`                   | Exact integers only (§3.3). |
| character     | `char?`         | `#\a`                  | A Unicode scalar value (§3.4). |
| string        | `string?`       | `"hi"`                 | Immutable sequence of characters. |
| symbol        | `symbol?`       | `foo`                  | Interned, except for `gensym` results. |
| empty list    | *(derived)*     | `()` (quoted)          | Exactly one object. |
| pair          | `pair?`         | `(a . b)` (quoted)     | Mutable. |
| vector        | `vector?`       | *(none)*               | Mutable, fixed length. |
| procedure     | `procedure?`    | *(none)*               | Primitives, closures, and continuations. |
| eof object    | `eof-object?`   | *(none)*               | Returned by `read-char`/`peek-char`. |
| unspecified   | *(none)*        | *(none)*               | See §3.6. |

`boolean?` and `null?` can be derived with `eq?`, so they are not primitives. Macros (§6) are *not* first-class objects and do not appear in this table.

### 3.2 Truthiness

Only `#f` counts as false. Every other object, including `()`, `0`, and `""`, counts as true [R7RS §6.3].

### 3.3 Integers

- Integers are exact.
- An implementation MUST support at least the range [−2²⁹, 2²⁹ − 1], and SHOULD support at least 64-bit signed integers or arbitrary precision.
- If a result falls outside the supported range, the implementation SHOULD signal an error. Silently wrapping around is permitted but not portable. Conformance tests stay inside the minimum range.
- There are no rational or floating-point numbers in the core. Rationals and bignums can be written in Seed itself (§12.3).

### 3.4 Characters and strings

- A character is a Unicode scalar value. Implementations MUST support code points 0–127 and SHOULD support all Unicode scalar values.
- Strings are immutable. The core offers only conversion to and from lists (§9.6). Everything else (`string-length`, `string-append`, `substring`, ...) is derived.
- Implementations SHOULD use UTF-8 for program text, standard input, and standard output.

### 3.5 Literal constants and mutation

Objects produced by the reader (quoted lists and string literals) are constants. Mutating them with `set-car!`, `set-cdr!`, or similar is an error [R7RS §3.4].

### 3.6 The unspecified value

Some expressions return an unspecified value, for example `set!`, `define`, a one-armed `if` whose test is false, `write-char`, and `vector-set!`. Implementations SHOULD return a single distinguished object for this, often called *void*. Programs MUST NOT depend on what it is. The idiom `(if #f #f)` produces it.

---

## 4. Programs and Execution Model

### 4.1 Programs

A *program* is a sequence of datums read from one or more source files. Each top-level datum is a *top-level form*. Top-level forms are evaluated in order, one at a time. Each form is fully evaluated, including any macro expansion, before the next one starts. Macros defined by one form are therefore available to every later form.

### 4.2 Environments and variables

- An *environment* maps identifiers (symbols) to *locations* that hold values [R7RS §3.1].
- There is one **global environment**. At startup it contains the primitive procedures from §9.
- Each procedure call creates a new **frame** that binds the procedure's parameters. The frame's parent is the environment the procedure was created in (*lexical scope*).
- Looking up a variable searches the frames from innermost to outermost and ends at the global environment. If the variable is not found, an error is signaled.
- **Primitive bindings are ordinary global variables.** A program MAY redefine them with `define` or `set!`. Any expression that refers to such a variable afterwards sees the new value. Implementations MUST NOT inline or constant-fold references to primitive names in a way that ignores redefinition. The library depends on this, for example to replace the binary `+` with a variadic one (Appendix B.3).

### 4.3 Special form keywords

The seven special form keywords `quote`, `if`, `lambda`, `define`, `set!`, `begin`, and `define-macro` are **reserved**. Binding one of them as a variable, parameter, or macro is an error.

### 4.4 Evaluation order

The operator and operands of a procedure call are evaluated in an unspecified order. Implementations do not have to use a consistent order [R7RS §4.1.3]. Every other ordering in this specification (inside `begin`, bodies, and `if`) is left to right as written.

### 4.5 Process interface

This is the contract between an implementation and the test harness.

- **Invocation.** `IMPL FILE...`. The implementation reads and evaluates each file in order, in one shared global environment, as one program. Implementations MAY offer other modes, such as a REPL when no files are given.
- **Standard input** is available only through `read-char` and `peek-char`. Program source is never read from standard input when files are given.
- **Standard output** receives exactly the characters written by `write-char`, and nothing else. Diagnostics go to standard error.
- **Exit status.** 0 when the last top-level form completes normally. Non-zero (SHOULD be 1) when an error is signaled (§10).
- **Flushing.** Buffered output MUST be flushed before the process exits, whether it exits normally or because of an error.

---

## 5. Expressions (Special Forms)

A form is evaluated as follows:

1. A **symbol** is a variable reference (§5.1).
2. An **integer, boolean, character, or string** evaluates to itself.
3. A **pair** whose `car` is a special form keyword is evaluated according to that form's rule below.
4. A **pair** whose `car` is a symbol bound to a macro is a macro use (§6).
5. Any other **pair** is a procedure call (§5.2).
6. Evaluating anything else, including `()`, is an error.

### 5.1 Variable reference

```scheme
variable
```

Returns the value stored in the location bound to `variable`. If `variable` is unbound, an error is signaled. If it is bound to a macro, it is an error. [R7RS §4.1.1]

### 5.2 Procedure call

```scheme
(operator operand ...)
```

Evaluates `operator` and every `operand` (order: §4.4), then applies the operator's value to the operands' values. If the operator's value is not a procedure, an error is signaled. [R7RS §4.1.3]

### 5.3 `quote`

```scheme
(quote datum)
```

Returns `datum` without evaluating it. `'datum` is the same thing. [R7RS §4.1.2]

```scheme
(quote (a b))   ⇒ (a b)
'()             ⇒ ()
```

### 5.4 `if`

```scheme
(if test consequent alternative)
(if test consequent)
```

Evaluates `test`. If the result is anything other than `#f`, evaluates `consequent` and returns its value. Otherwise evaluates `alternative` and returns its value, or returns the unspecified value if there is no `alternative`. Both `consequent` and `alternative` are in tail position (§7). [R7RS §4.1.5]

### 5.5 `lambda`

```scheme
(lambda formals body ...+)
```

Creates a procedure (a *closure*) that captures the current environment. `formals` takes one of three shapes [R7RS §4.1.4]:

| `formals`             | Meaning |
|-----------------------|---------|
| `(x1 ... xn)`         | Exactly *n* arguments. |
| `(x1 ... xn . rest)`  | At least *n* arguments. Any extras are collected in a fresh list bound to `rest`. |
| `rest`                | Any number of arguments, all collected in a fresh list bound to `rest`. |

When the procedure is called:

1. If the number of arguments does not fit `formals`, an error is signaled.
2. A new frame whose parent is the captured environment binds each parameter to a fresh location holding its argument.
3. The `body` forms are evaluated in order in that frame. The value of the last form is returned. The last form is in tail position.

The body MUST contain at least one form. A parameter name that appears more than once in `formals` is an error.

### 5.6 `define`

```scheme
(define variable expression)
(define (variable . formals) body ...+)
```

The second form is shorthand for `(define variable (lambda formals body ...))`. Here `formals` uses the same syntax as `lambda`, so `(define (f . args) ...)` and `(define (f a b . rest) ...)` both work. [R7RS §5.3]

- **At top level**, `define` evaluates `expression` and binds `variable` in the global environment. If `variable` is already bound, `define` behaves like `set!`.
- **Internal definitions.** In a `lambda` body, `define` binds `variable` in the frame created for that call. Definitions MUST come before any other forms in the body. Referring to an internally defined variable before its `define` has run is an error. This gives `letrec*` semantics [R7RS §5.3.2, §4.2.2].
- `define` is allowed only at top level, at the start of a body, or inside a `begin` that is itself in one of those positions. Anywhere else it is an error.
- The value of a `define` form is unspecified.

### 5.7 `set!`

```scheme
(set! variable expression)
```

Evaluates `expression` and stores the result in the location `variable` is bound to. If `variable` is unbound, an error is signaled. The value of the form is unspecified. [R7RS §4.1.6]

### 5.8 `begin`

```scheme
(begin form ...)
```

Evaluates the `form`s in order and returns the value of the last one, which is in tail position. `begin` does **not** create a new environment frame. When `begin` appears where a definition is allowed, any definitions inside it are spliced into the surrounding context. This lets a macro expand into several top-level definitions [R7RS §4.2.3, §5.1].

`(begin)` with no forms is allowed only at top level, where it does nothing. Anywhere else it is an error.

### 5.9 `define-macro`

```scheme
(define-macro (name . formals) body ...+)
```

Defines a macro. See §6.

---

## 6. Macros

Seed's core macro system is the classic non-hygienic, procedural "defmacro" style [Graham 1993, ch. 7; Gambit, Guile, and Chicken all provide `define-macro`]. Hygienic systems such as `syntax-rules` can be built on top of it (§12.3).

### 6.1 Definition

```scheme
(define-macro (name . formals) body ...+)
```

- This form is allowed only at top level, including inside a top-level `begin`.
- It evaluates `(lambda formals body ...)` in the global environment, producing the *transformer*. It then binds `name` in the global environment to a *macro object* that holds the transformer.
- Redefining a macro replaces the old one. Defining a macro with the name of an existing global variable replaces that variable's binding, and vice versa.

### 6.2 Expansion

Suppose `(name operand ...)` is being evaluated, `name` is a symbol, and `name` is bound to a macro. Then:

1. The transformer is applied to the operands **as unevaluated data**. That is, `(apply transformer '(operand ...))`.
2. The result, the *expansion*, is evaluated **in place of** the original form, in the same environment and in the same tail or non-tail position. If the expansion is itself a macro use, it is expanded again.

Additional rules:

- **Shadowing.** Binding a macro's name as a local variable or parameter is an error. This lets implementations recognize macro uses without tracking lexical scope, so a separate expansion pass works too.
- **Timing.** Implementations MAY expand each time a form is evaluated, expand once and cache the result, or expand a whole top-level form before evaluating it. Conforming programs MUST NOT depend on how many times or when a transformer runs. Transformers SHOULD be pure functions of their input, apart from calling `gensym`.
- **First-class use.** A macro name may appear only in operator position. Any other use is an error.

### 6.3 Hygiene

Because expansion is not hygienic, a library author is responsible for two things [Kohlbecker et al. 1986]:

1. **No variable capture.** Use `gensym` (§9.6) for any variable the expansion introduces.
2. **No reference capture.** An expansion that refers to a global name such as `cons` will see a local binding of `cons` at the use site. Libraries can lessen this with private aliases (for example, `(define %cons cons)` and expanding to `%cons`).

---

## 7. Proper Tail Recursion

Implementations **MUST** be properly tail-recursive [R7RS §3.5, Clinger 1998]. The number of active tail calls has no limit. A loop written as a tail call MUST run in bounded space no matter how many iterations it makes.

A form is in **tail position** if it is:

- the last form of a `lambda` body;
- the `consequent` or `alternative` of an `if` that is in tail position;
- the last form of a `begin` that is in tail position;
- the expansion of a macro use that is in tail position.

In addition, these are **tail calls**:

- `apply` calls its procedure argument as a tail call;
- `call/cc` calls its procedure argument as a tail call.

Invoking a continuation (§8) abandons the current continuation, so it never uses up stack space.

---

## 8. Continuations

### 8.1 `call/cc`

```scheme
(call/cc proc)
```

Packages the current continuation as an *escape procedure* and calls `proc` with it as the only argument [R7RS §6.10]. The escape procedure is an ordinary procedure (`procedure?` returns `#t` for it) with these properties:

- It takes **exactly one** argument. Calling it with any other number of arguments signals an error.
- Calling it with `v` abandons whatever continuation is in effect and makes `call/cc` return `v` again.
- Continuations have **unlimited extent**. They can be stored and called any number of times, including after the `call/cc` that created them has returned (re-entry) [Haynes, Friedman & Wand 1984].

### 8.2 Top-level continuations

A continuation captured while evaluating top-level form *T* reaches only to the end of *T*. Suppose it is called while a later top-level form *U* is running. The rest of *U* is abandoned, the rest of *T* runs, and then evaluation continues with the top-level form that follows *U*. Re-entry does not cause the forms between *T* and *U* to be evaluated again.

### 8.3 What is not in the core

`dynamic-wind`, multiple values (`values` and `call-with-values`), and exceptions (`raise`, `with-exception-handler`, `guard`) are **not** core. Each of them can be derived in the library from `call/cc` and closures (§12.3, Appendix B.6).

---

## 9. Primitive Procedures

There are 38 primitives. Unless stated otherwise:

- each primitive takes a **fixed number of arguments**, and calling it with a different number signals an error;
- an argument of the wrong type signals an error.

The **Kind** column says whether a primitive is *essential* (no other primitive can derive it) or included for *efficiency* (derivable, but the derivation is asymptotically slower). See §12.2.

### 9.1 Pairs

| Signature              | Kind | Description |
|------------------------|------|-------------|
| `(cons obj1 obj2)`     | essential | Returns a newly allocated pair whose car is `obj1` and whose cdr is `obj2`. |
| `(car pair)`           | essential | Returns the car of `pair`. |
| `(cdr pair)`           | essential | Returns the cdr of `pair`. |
| `(set-car! pair obj)`  | essential | Stores `obj` in the car of `pair`. Returns the unspecified value. |
| `(set-cdr! pair obj)`  | essential | Stores `obj` in the cdr of `pair`. Returns the unspecified value. |

Reference: [R7RS §6.4].

### 9.2 Type predicates

Each predicate takes one argument of any type and returns `#t` or `#f`.

| Signature               | Kind | Returns `#t` if `obj` is ... |
|-------------------------|------|------------------------------|
| `(pair? obj)`           | essential | a pair |
| `(symbol? obj)`         | essential | a symbol (including gensyms) |
| `(number? obj)`         | essential | an integer |
| `(char? obj)`           | essential | a character |
| `(string? obj)`         | essential | a string |
| `(vector? obj)`         | essential | a vector |
| `(procedure? obj)`      | essential | a primitive, closure, or continuation |
| `(eof-object? obj)`     | essential | the eof object |

### 9.3 Identity

| Signature          | Kind | Description |
|--------------------|------|-------------|
| `(eq? obj1 obj2)`  | essential | Returns `#t` if `obj1` and `obj2` are the same object, otherwise `#f`. |

`eq?` MUST return `#t` in these cases:

- the two arguments are interned symbols with the same name;
- both are `#t`, or both are `#f`;
- both are the empty list;
- both are the same pair, vector, string, or procedure (that is, the same allocation).

`eq?` MUST return `#f` when the arguments have different types (§3.1), and for two pairs, vectors, or procedures that were allocated separately.

For integers and characters the result of `eq?` is unspecified [R7RS §6.1]. To compare them portably, use `=`, or derive `eqv?` (Appendix B.2).

### 9.4 Integers

| Signature               | Kind | Description |
|-------------------------|------|-------------|
| `(+ k1 k2)`             | essential  | Sum. |
| `(- k1 k2)`             | essential  | Difference. |
| `(* k1 k2)`             | efficiency | Product. |
| `(quotient k1 k2)`      | efficiency | `k1 / k2`, truncated toward zero. Signals an error if `k2` is 0. |
| `(remainder k1 k2)`     | efficiency | `k1 - k2 * (quotient k1 k2)`. Has the sign of `k1`. Signals an error if `k2` is 0. |
| `(= k1 k2)`             | essential  | `#t` if the two integers are equal. |
| `(< k1 k2)`             | essential  | `#t` if `k1` is less than `k2`. |

All of these are **binary**. The library defines the variadic versions (`(+)`, `(+ 1 2 3)`, `(- x)`, `(< a b c)`), along with `>`, `<=`, `>=`, `modulo`, `abs`, `gcd`, `expt`, `number->string`, `string->number`, and so on. Reference: [R7RS §6.2.6].

### 9.5 Characters

| Signature                | Kind | Description |
|--------------------------|------|-------------|
| `(char->integer char)`   | essential | Returns the Unicode code point of `char`. |
| `(integer->char k)`      | essential | Returns the character whose code point is `k`. Signals an error if `k` is not a supported Unicode scalar value. |

Reference: [R7RS §6.6].

### 9.6 Strings and symbols

| Signature                  | Kind | Description |
|----------------------------|------|-------------|
| `(string->list str)`       | essential | Returns a newly allocated list of the characters of `str`. |
| `(list->string list)`      | essential | Returns a newly allocated string made of the characters in `list`. Signals an error if `list` is not a proper list of characters. |
| `(symbol->string sym)`     | essential | Returns the name of `sym` as a string. For an interned symbol this is the name exactly as it was read or created. Mutating the result is an error. |
| `(string->symbol str)`     | essential | Returns the interned symbol named `str`, creating it if needed. Calling it twice with equal strings returns the same (`eq?`) symbol. |
| `(gensym)`                 | essential | Returns a newly created **uninterned** symbol. It is not `eq?` to any other symbol, including any symbol later produced by `string->symbol` from its name. The name is implementation-defined. |

Reference: [R7RS §6.5, §6.7]. `gensym` is not part of R7RS but is common in implementations; see [Dybvig 2009] and [Graham 1993].

### 9.7 Vectors

| Signature                    | Kind | Description |
|------------------------------|------|-------------|
| `(make-vector k obj)`        | efficiency | Returns a new vector of length `k` with every element set to `obj`. Signals an error if `k` is negative. |
| `(vector-length vec)`        | efficiency | Returns the number of elements in `vec`. |
| `(vector-ref vec k)`         | efficiency | Returns element `k` of `vec`. Signals an error if `k` is out of range. |
| `(vector-set! vec k obj)`    | efficiency | Stores `obj` in element `k`. Signals an error if `k` is out of range. Returns the unspecified value. |

Reference: [R7RS §6.8]. Vectors can be emulated with lists, but only with O(n) access (§12.2).

### 9.8 Control

| Signature                     | Kind | Description |
|-------------------------------|------|-------------|
| `(apply proc list)`           | essential | Calls `proc` with the elements of `list` as its arguments, as a tail call. Signals an error if `list` is not a proper list. This core version takes **exactly two** arguments; the library defines the variadic `(apply f a b '(c d))`. |
| `(call/cc proc)`              | essential | See §8. The library defines `call-with-current-continuation` as an alias. |
| `(error obj ...)`             | essential | Signals an error (§10). **Variadic.** The first argument SHOULD be a message string. The remaining arguments are *irritants* that the implementation SHOULD include in its diagnostic. |

### 9.9 Input and output

All input comes from standard input and all output goes to standard output (§4.5).

| Signature              | Kind | Description |
|------------------------|------|-------------|
| `(read-char)`          | essential  | Removes the next character from standard input and returns it. Returns the eof object at end of input. |
| `(peek-char)`          | efficiency | Returns the next character from standard input without removing it. Returns the eof object at end of input. |
| `(write-char char)`    | essential  | Writes `char` to standard output. Returns the unspecified value. |

`display`, `write`, `newline`, `read`, and `read-line` are all derived in the library. Reference: [R7RS §6.13].

### 9.10 Summary

```
Special forms (7):  quote  if  lambda  define  set!  begin  define-macro

Primitives (38):
  pairs       cons car cdr set-car! set-cdr!
  types       pair? symbol? number? char? string? vector? procedure? eof-object?
  identity    eq?
  integers    + - * quotient remainder = <
  chars       char->integer integer->char
  strings     string->list list->string symbol->string string->symbol gensym
  vectors     make-vector vector-length vector-ref vector-set!
  control     apply call/cc error
  i/o         read-char peek-char write-char
```

---

## 10. Errors

When an error is signaled, the implementation MUST:

1. stop evaluating the program, without running any further top-level forms;
2. flush standard output;
3. write a diagnostic to standard error (format implementation-defined; SHOULD name the condition and the offending objects);
4. exit with a non-zero status (SHOULD be 1).

The core has no way to catch a signaled error. A library exception system built on `call/cc` (Appendix B.6) can catch errors raised by the library's own `raise` and `error`, but not errors signaled by primitives. Implementations MAY offer a hook for this as an extension.

Implementations MUST signal an error for all of the following:

| Condition | Where |
|-----------|-------|
| Reference to or `set!` of an unbound variable | §5.1, §5.7 |
| Calling a non-procedure | §5.2 |
| Wrong number of arguments to a closure, primitive, or continuation | §5.5, §8.1, §9 |
| Wrong argument type to a primitive | §9 |
| Division by zero | §9.4 |
| Vector index out of range; negative vector length | §9.7 |
| Invalid code point given to `integer->char` | §9.5 |
| Improper list given to `apply` or `list->string` | §9.6, §9.8 |
| Malformed special form (wrong shape, non-symbol variable) | §5 |
| Syntax error while reading (unbalanced parentheses, bad token) | §2 |
| An explicit call to `error` | §9.8 |

Everything else described as "it is an error" in this document is undefined behavior.

---

## 11. Conformance

### 11.1 Conforming implementations

An implementation conforms if it:

1. accepts every program that follows §2 and behaves as §§3–10 specify;
2. follows the process interface in §4.5;
3. is properly tail-recursive (§7);
4. supports re-entrant continuations with unlimited extent (§8).

### 11.2 Conforming programs

A program conforms if it uses only the features in this document and does nothing this document calls "an error" or "unspecified".

### 11.3 Extensions

An implementation MAY add special forms, primitives, reader syntax, or a REPL, as long as no conforming program behaves differently because of them. In particular:

- extra global bindings MUST be redefinable by programs, just like the primitives (§4.2);
- extra special form keywords SHOULD be avoided or made optional, because they reserve names (§4.3).

Common extensions include `eval`, `exit`, `load`, floating-point numbers, string ports, file I/O, `current-time`, and a built-in printer for debugging.

---

## 12. Rationale (informative)

### 12.1 The "Maxwell's equations" idea

Alan Kay described the half page of `eval` and `apply` in the *LISP 1.5 Programmer's Manual* [McCarthy et al. 1962, p. 13] as "the Maxwell's Equations of Software" [Kay 2004]. Seed tries to be that kernel for Scheme: the smallest set of laws from which the rest of the language follows. Graham's *The Roots of Lisp* [Graham 2002] shows that seven operators are enough for pure symbolic computation. Seed adds what a *practical* Scheme can't be bootstrapped without: mutation, tail calls, continuations, macros, characters and strings, and I/O.

### 12.2 Why each feature is in the core

| Feature | Reason |
|---------|--------|
| `quote`, `if`, `lambda`, `define`, `set!` | The irreducible special forms of Scheme [R7RS §4.1, Steele & Sussman 1976]. `define` could be emulated with a global association list and `set!`, but that would make every global lookup O(n). |
| `begin` | `((lambda () ...))` gives sequencing but not *splicing*. Without `begin`, a macro could not expand into several top-level definitions, so `define-record-type` could not be written. |
| `define-macro` | Syntactic extension is how `let`, `cond`, `and`, `or`, `do`, `case`, `quasiquote`, and `define-record-type` get into the library. A procedural defmacro is the smallest mechanism that can build all of them, including `syntax-rules`, whose pattern language comes from [Kohlbecker & Wand 1987]. |
| `call/cc` | First-class continuations cannot be expressed with the other core forms unless the whole program is rewritten in continuation-passing style [Reynolds 1972]. With them come `dynamic-wind`, exceptions, generators, coroutines, and backtracking. |
| `apply` | Without it, there is no way to call a procedure with an argument list whose length is only known at run time. |
| `gensym` | Needed to write macros that don't capture variables. A counter plus `string->symbol` can only approximate it, since a user symbol could collide. |
| Binary arithmetic | Variadic arithmetic is easy to derive. Keeping primitives fixed-arity makes them simpler to implement. `*`, `quotient`, and `remainder` can be derived from `+`, `-`, and `<` with repeated addition, but that is far too slow to use. |
| `string->list` / `list->string` | The smallest bridge between string literals and the list world. `string-length`, `string-ref`, and so on are O(n) when derived. That is fine for a teaching core; an implementation may add faster versions as extensions. |
| Vectors | Only needed for O(1) indexed access (hash tables, `syntax-rules` pattern variables, records). A list-based emulation has the same meaning but O(n) access. |
| `peek-char` | Lets a reader written in Seed run without a global push-back buffer. |
| Type predicates | The types are disjoint (§3.1), and an object's type cannot be found out any other way. `boolean?` and `null?` are left out because `eq?` against the unique objects derives them. |

### 12.3 What is derived (informative roadmap)

A Seed library can provide the following R7RS-small features. Section numbers refer to [R7RS].

| R7RS feature | How to derive it |
|--------------|------------------|
| `list`, `null?`, `boolean?`, `not`, `cadr`, ... | Plain procedures. `(define (list . xs) xs)` |
| `let`, `let*`, `letrec`, `letrec*`, named `let` (§4.2.2) | Macros that expand into `lambda` and internal `define` [R7RS §7.3]. |
| `and`, `or`, `when`, `unless`, `cond`, `case`, `do` (§4.2.1, §4.2.4) | Macros that expand into `if` and `let`, using `gensym` for temporaries. |
| `quasiquote` (§4.2.8) | A macro over the reader's `quasiquote`/`unquote` forms [Bawden 1999]. |
| `eqv?`, `equal?` (§6.1) | Recursive procedures built on `eq?`, `=`, and the type predicates. |
| Variadic arithmetic, comparisons, `abs`, `gcd`, `lcm`, `expt`, `modulo` (§6.2.6) | Folds over the binary primitives. |
| Bignums and rationals (§6.2) | Lists or vectors of limbs; pairs of integers normalized with `gcd` [Knuth 1997, §4.3.1]. |
| `number->string`, `string->number` | Digit loops using `quotient`, `remainder`, and `integer->char`. |
| List library (§6.4): `length`, `append`, `reverse`, `list-tail`, `list-ref`, `memq`, `member`, `assq`, `assoc`, `map`, `for-each` | Ordinary recursive procedures. |
| Character and string library (§6.6, §6.7) | Built on `char->integer` and conversion through lists. |
| `display`, `write`, `newline` (§6.13) | A printer written with `write-char` and type dispatch. |
| `read` (§6.13) | A reader written with `read-char` and `peek-char`. This is a good exercise: the language reads itself. |
| `dynamic-wind` (§6.10) | Keep a global list of winders and redefine `call/cc` so it rewinds and unwinds [Dybvig 2009; Friedman & Haynes 1985]. |
| `values`, `call-with-values` (§6.10) | Represent multiple values as a tagged list. |
| `raise`, `with-exception-handler`, `guard`, `error` (§6.11) | A handler stack plus `call/cc` for non-local exit. |
| `delay`, `force`, `make-promise` (§4.2.5) | Memoizing closures, using a macro for `delay`. |
| `define-record-type` (§5.5) | A macro expanding to `begin` + definitions over tagged vectors. |
| `syntax-rules` (§4.3.2) | A pattern matcher and template expander written as a `define-macro` transformer. A non-hygienic version is a moderate exercise; a hygienic one needs renaming [Clinger & Rees 1991; Dybvig, Hieb & Bruggeman 1993]. |
| `eval` (§6.12) | A metacircular evaluator written in Seed [Abelson & Sussman 1996, ch. 4]. |

Not derivable, so left to extensions: floating-point arithmetic (it can be emulated in software, but impractically), file and network ports, system time, environment variables, and process exit codes other than 0 and 1 (`error` gives 1).

---

## Appendix A: Reference Evaluator (informative)

This pseudocode gives the meaning of the core, in the spirit of the LISP 1.5 `eval`/`apply` [McCarthy et al. 1962] and the SICP metacircular evaluator [Abelson & Sussman 1996, §4.1]. In most host languages, transcribing this pseudocode directly as recursive functions will not meet the requirements of §7 and §8. How you meet them is a design decision left to you.

```text
eval(x, env):
  if x is a symbol:
      v ← lookup(env, x)                 ; error if unbound (§5.1)
      return v                           ; error if v is a macro
  if x is integer | boolean | char | string:
      return x
  if x is not a pair:
      error "cannot evaluate"            ; includes ()
  op ← car(x)
  case op:
    'quote        → return cadr(x)
    'if           → if eval(cadr(x), env) ≠ #f
                       then TAIL eval(caddr(x), env)
                       else if cdddr(x) ≠ () then TAIL eval(cadddr(x), env)
                            else return UNSPECIFIED
    'lambda       → return Closure(params=cadr(x), body=cddr(x), env)
    'define       → (name, valexpr) ← normalize-define(x)
                    define-in-frame(env, name, eval(valexpr, env))
                    return UNSPECIFIED
    'set!         → assign(env, cadr(x), eval(caddr(x), env))  ; error if unbound
                    return UNSPECIFIED
    'begin        → return TAIL eval-sequence(cdr(x), env)
    'define-macro → (name . formals) ← cadr(x)
                    t ← eval(cons('lambda, cons(formals, cddr(x))), GLOBAL)
                    define-in-frame(GLOBAL, name, Macro(t))
                    return UNSPECIFIED
  if op is a symbol and lookup(env, op) is Macro(t):
      return TAIL eval(apply(t, cdr(x)), env)        ; §6.2
  f    ← eval(op, env)                               ; order unspecified (§4.4)
  args ← [eval(a, env) for a in cdr(x)]
  return TAIL apply(f, args)

apply(f, args):
  case f:
    Primitive(p)          → return p(args)           ; arity/type checks (§9)
    Closure(ps, body, e)  → frame ← new Frame(parent=e)
                            bind(frame, ps, args)    ; error on arity mismatch
                            return TAIL eval-sequence(body, frame)
    Continuation(k)       → require |args| = 1
                            abandon current continuation; resume k with args[0]
    otherwise             → error "not a procedure"

eval-sequence(forms, env):
  for each form except the last: eval(form, env)
  return TAIL eval(last(forms), env)
```

`TAIL` marks a call in tail position. The implementation MUST NOT grow the control context for it (§7).

---

## Appendix B: Bootstrapping Examples (informative)

These excerpts show how the library starts out. Order matters: a macro can only use procedures and macros defined before it is *used*, because its transformer runs at expansion time.

### B.1 First procedures

```scheme
(define (list . xs) xs)
(define (null? x) (eq? x '()))
(define (not x) (if x #f #t))
(define (boolean? x) (if (eq? x #t) #t (eq? x #f)))
(define (cadr x) (car (cdr x)))
(define (cddr x) (cdr (cdr x)))
(define (caar x) (car (car x)))

(define (map1 f xs)
  (if (null? xs) '() (cons (f (car xs)) (map1 f (cdr xs)))))

(define (append2 a b)
  (if (null? a) b (cons (car a) (append2 (cdr a) b))))
```

### B.2 Equivalence

```scheme
(define (eqv? a b)
  (if (eq? a b) #t
      (if (number? a)
          (if (number? b) (= a b) #f)
          (if (char? a)
              (if (char? b) (= (char->integer a) (char->integer b)) #f)
              #f))))
```

### B.3 Variadic arithmetic

The primitive is captured *before* the global name is rebound (§4.2):

```scheme
(define (fold-left f acc xs)
  (if (null? xs) acc (fold-left f (f acc (car xs)) (cdr xs))))

(define +
  ((lambda (add) (lambda xs (fold-left add 0 xs)))
   +))

(define -
  ((lambda (sub)
     (lambda (x . xs)
       (if (null? xs) (sub 0 x) (fold-left sub x xs))))
   -))
```

### B.4 Core derived syntax

```scheme
(define-macro (let bindings . body)
  (cons (cons 'lambda (cons (map1 car bindings) body))
        (map1 cadr bindings)))

(define-macro (and . xs)
  (if (null? xs) #t
      (if (null? (cdr xs)) (car xs)
          (list 'if (car xs) (cons 'and (cdr xs)) #f))))

(define-macro (or . xs)
  (if (null? xs) #f
      (if (null? (cdr xs)) (car xs)
          (let ((t (gensym)))
            (list 'let (list (list t (car xs)))
                  (list 'if t t (cons 'or (cdr xs))))))))

(define-macro (cond . clauses)
  (if (null? clauses)
      '(if #f #f)
      (let ((c (car clauses)))
        (if (eq? (car c) 'else)
            (cons 'begin (cdr c))
            (list 'if (car c)
                  (cons 'begin (cdr c))
                  (cons 'cond (cdr clauses)))))))
;; Left as exercises: clauses with no body, `=>` clauses, named let, let*, letrec.

;; Quasiquote without nesting levels (see [Bawden 1999] for the full algorithm).
(define (qq-expand x)
  (cond ((not (pair? x)) (list 'quote x))
        ((eq? (car x) 'unquote) (cadr x))
        ((and (pair? (car x)) (eq? (caar x) 'unquote-splicing))
         (list 'append2 (cadr (car x)) (qq-expand (cdr x))))
        (else (list 'cons (qq-expand (car x)) (qq-expand (cdr x))))))

(define-macro (quasiquote x) (qq-expand x))
```

### B.5 Output

```scheme
(define (newline) (write-char #\newline))

(define (display-string s)
  (for-each-char write-char (string->list s)))
(define (for-each-char f cs)
  (if (null? cs) #t (begin (f (car cs)) (for-each-char f (cdr cs)))))

(define (display-integer n)
  (if (< n 0)
      (begin (write-char #\-) (display-digits (- 0 n)))
      (display-digits n)))
(define (display-digits n)            ; n ≥ 0
  (if (< n 10)
      (write-char (integer->char (+ 48 n)))
      (begin (display-digits (quotient n 10))
             (write-char (integer->char (+ 48 (remainder n 10)))))))
```

### B.6 Control: sketch of `dynamic-wind`

```scheme
(define *winders* '())

(define (dynamic-wind before thunk after)
  (before)
  (set! *winders* (cons (cons before after) *winders*))
  (let ((result (thunk)))
    (set! *winders* (cdr *winders*))
    (after)
    result))

;; Then redefine call/cc so that each captured continuation records
;; *winders*. On invocation it runs the `after` thunks of the frames being
;; left and the `before` thunks of the frames being entered (common-ancestor
;; walk), and only then calls the raw continuation.
;; See [Dybvig 2009] and [R7RS §6.10].
```

---

## Appendix C: Conformance Examples

Every example uses only the core. `⇒` gives the value the expression returns. A test harness would print values with a Seed printer (Appendix B.5) and compare standard output.

### C.1 Literals and quote

```scheme
42                         ⇒ 42
-7                         ⇒ -7
#t                         ⇒ #t
#\a                        ⇒ #\a
"hi"                       ⇒ "hi"
'foo                       ⇒ foo
'(1 . 2)                   ⇒ (1 . 2)
'(1 2 . (3))               ⇒ (1 2 3)
''a                        ⇒ (quote a)
'`(a ,b ,@c)               ⇒ (quasiquote (a (unquote b) (unquote-splicing c)))
(eq? 'abc 'abc)            ⇒ #t
(eq? 'abc 'ABC)            ⇒ #f
(symbol? '+)               ⇒ #t
(number? '+5)              ⇒ #t
```

### C.2 Core forms

```scheme
(if #f 1 2)                ⇒ 2
(if '() 1 2)               ⇒ 1
(if 0 1 2)                 ⇒ 1
((lambda (x y) (- x y)) 10 3)            ⇒ 7
((lambda args args) 1 2 3)               ⇒ (1 2 3)
((lambda (a . rest) rest) 1 2 3)         ⇒ (2 3)
((lambda (a . rest) rest) 1)             ⇒ ()
(begin 1 2 3)                            ⇒ 3

(define x 1)
(set! x (+ x 1))
x                                        ⇒ 2

(define (make-counter)
  ((lambda (n) (lambda () (set! n (+ n 1)) n)) 0))
(define c (make-counter))
(c)                                      ⇒ 1
(c)                                      ⇒ 2

(define (f)
  (define a 10)
  (define (g) (* a 2))
  (g))
(f)                                      ⇒ 20
```

### C.3 Redefinition of primitives

```scheme
(define (twice) (car '(1 2)))
(define old-car car)
(define car (lambda (p) 'redefined))
(twice)                                  ⇒ redefined
(set! car old-car)
(twice)                                  ⇒ 1
```

### C.4 Proper tail recursion (MUST run in bounded space)

```scheme
(define (loop n) (if (= n 0) 'done (loop (- n 1))))
(loop 1000000)                           ⇒ done

(define (even? n) (if (= n 0) #t (odd? (- n 1))))
(define (odd? n)  (if (= n 0) #f (even? (- n 1))))
(even? 1000001)                          ⇒ #f

(define (loop2 n) (if (= n 0) 'done (begin 'x (apply loop2 (cons (- n 1) '())))))
(loop2 1000000)                          ⇒ done
```

### C.5 Macros

These examples use `let` and `list`, so they assume the library from Appendix B.1 and B.4 is loaded.

```scheme
(define-macro (swap! a b)
  (let ((tmp (gensym)))
    (list 'let (list (list tmp a))
          (list 'set! a b)
          (list 'set! b tmp))))
(define p 1)
(define q 2)
(swap! p q)
(list p q)                               ⇒ (2 1)

(define-macro (my-if c a b) (list 'if c a b))
(define (count n) (my-if (= n 0) 'ok (count (- n 1))))
(count 1000000)                          ⇒ ok        ; macro use in tail position

(eq? (gensym) (gensym))                  ⇒ #f
(symbol? (gensym))                       ⇒ #t
```

### C.6 Continuations

```scheme
(+ 1 (call/cc (lambda (k) (+ 10 (k 1)))))          ⇒ 2

(define (find-first pred xs)
  (call/cc
    (lambda (return)
      ((lambda (walk) (set! walk (lambda (l)
                                   (if (pair? l)
                                       (begin (if (pred (car l)) (return (car l)) #f)
                                              (walk (cdr l)))
                                       #f)))
                      (walk xs))
       #f))))
(find-first (lambda (n) (< 2 n)) '(1 2 3 4))       ⇒ 3

;; Re-entry within a single top-level form
(define (test-reentry)
  ((lambda (k n)
     ((lambda (v)
        (set! n (+ n 1))
        (if (< v 3) (k (+ v 1)) n))
      (call/cc (lambda (c) (set! k c) 0))))
   #f 0))
(test-reentry)                                     ⇒ 4
```

### C.7 Characters, strings, vectors

```scheme
(char->integer #\A)                      ⇒ 65
(integer->char 97)                       ⇒ #\a
(string->list "abc")                     ⇒ (#\a #\b #\c)
(list->string (cons #\h (cons #\i '()))) ⇒ "hi"
(eq? (string->symbol "abc") 'abc)        ⇒ #t
(symbol->string 'Hello)                  ⇒ "Hello"
(string->list "a\"b\\c\n")               ⇒ (#\a #\" #\b #\\ #\c #\newline)

(define v (make-vector 3 0))
(vector-set! v 1 'x)
(vector-ref v 1)                         ⇒ x
(vector-length v)                        ⇒ 3
```

### C.8 Must signal an error (non-zero exit status)

Run each of these as a separate program:

```scheme
(car '())
(undefined-variable)
((lambda (x) x))
(quotient 1 0)
(vector-ref (make-vector 2 0) 2)
(1 2 3)
(error "boom" 42)
```

---

## References

- **[Abelson & Sussman 1996]** H. Abelson, G. J. Sussman, J. Sussman. *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press, 1996. Chapter 4 (metacircular evaluator), Chapter 5 (register machines and explicit-control evaluator). <https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html>
- **[Baker 1995]** H. G. Baker. "CONS Should Not CONS Its Arguments, Part II: Cheney on the M.T.A." *ACM SIGPLAN Notices* 30(9), 1995. A technique for tail calls and continuations in C.
- **[Bawden 1999]** A. Bawden. "Quasiquotation in Lisp." *Proc. PEPM '99*, 1999.
- **[Clinger 1998]** W. D. Clinger. "Proper Tail Recursion and Space Efficiency." *Proc. PLDI '98*, 1998.
- **[Clinger & Rees 1991]** W. Clinger, J. Rees. "Macros That Work." *Proc. POPL '91*, 1991.
- **[Dybvig 1987]** R. K. Dybvig. *Three Implementation Models for Scheme*. PhD thesis, University of North Carolina at Chapel Hill, 1987.
- **[Dybvig 2009]** R. K. Dybvig. *The Scheme Programming Language*, 4th ed. MIT Press, 2009. <https://www.scheme.com/tspl4/>
- **[Dybvig, Hieb & Bruggeman 1993]** R. K. Dybvig, R. Hieb, C. Bruggeman. "Syntactic Abstraction in Scheme." *Lisp and Symbolic Computation* 5(4), 1993.
- **[Friedman & Haynes 1985]** D. P. Friedman, C. T. Haynes. "Constraining Control." *Proc. POPL '85*, 1985.
- **[Graham 1993]** P. Graham. *On Lisp*. Prentice Hall, 1993. Chapters 7–9 on defmacro-style macros and variable capture. <https://paulgraham.com/onlisp.html>
- **[Graham 2002]** P. Graham. "The Roots of Lisp." 2002. <https://paulgraham.com/rootsoflisp.html>
- **[Haynes, Friedman & Wand 1984]** C. T. Haynes, D. P. Friedman, M. Wand. "Continuations and Coroutines." *Proc. ACM Symposium on LISP and Functional Programming*, 1984.
- **[Kay 2004]** S. Feldman. "A Conversation with Alan Kay." *ACM Queue* 2(9), 2004. <https://queue.acm.org/detail.cfm?id=1039523>
- **[Knuth 1997]** D. E. Knuth. *The Art of Computer Programming, Vol. 2: Seminumerical Algorithms*, 3rd ed. Addison-Wesley, 1997.
- **[Kohlbecker et al. 1986]** E. Kohlbecker, D. P. Friedman, M. Felleisen, B. Duba. "Hygienic Macro Expansion." *Proc. ACM Conference on LISP and Functional Programming*, 1986.
- **[Kohlbecker & Wand 1987]** E. Kohlbecker, M. Wand. "Macro-by-Example: Deriving Syntactic Transformations from Their Specifications." *Proc. POPL '87*, 1987.
- **[McCarthy 1960]** J. McCarthy. "Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I." *Communications of the ACM* 3(4), 1960.
- **[McCarthy et al. 1962]** J. McCarthy et al. *LISP 1.5 Programmer's Manual*. MIT Press, 1962.
- **[Queinnec 1996]** C. Queinnec. *Lisp in Small Pieces*. Cambridge University Press, 1996.
- **[R7RS]** A. Shinn, J. Cowan, A. A. Gleckler (eds.). *Revised⁷ Report on the Algorithmic Language Scheme* (R7RS-small). 2013. <https://small.r7rs.org/attachment/r7rs.pdf>
- **[Reynolds 1972]** J. C. Reynolds. "Definitional Interpreters for Higher-Order Programming Languages." *Proc. ACM Annual Conference*, 1972.
- **[RFC 2119]** S. Bradner. "Key words for use in RFCs to Indicate Requirement Levels." IETF, 1997. <https://www.rfc-editor.org/rfc/rfc2119>
- **[Sussman & Steele 1975]** G. J. Sussman, G. L. Steele Jr. "Scheme: An Interpreter for Extended Lambda Calculus." MIT AI Memo 349, 1975.
- **[Steele & Sussman 1976]** G. L. Steele Jr., G. J. Sussman. "Lambda: The Ultimate Imperative." MIT AI Memo 353, 1976.
