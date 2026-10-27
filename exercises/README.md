# Seed exercises

A step-by-step path from an empty file to a complete Seed interpreter. The course is split into sections, and each section into small stages. Every stage names the features to support and comes with tests your interpreter must pass. Completing a section unlocks parts of the [specification](../spec.md).

The stages say **what** to support, never **how**. Representation, evaluation strategy, and error handling are your design decisions. Sometimes a later stage will make you revisit an earlier decision; that is part of the exercise.

The pacing follows the incremental style of [Make a Lisp](https://github.com/kanaka/mal), Ghuloum's [*An Incremental Approach to Compiler Construction*](http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf), and the [CodeCrafters interpreter course](https://app.codecrafters.io/courses/interpreter/overview). You read and print data before evaluating anything, evaluate data before calling procedures, and call built-in procedures before defining your own.

## Checklist

Tick each stage (`[ ]` → `[x]`) as its tests pass. To see your real status, run `./run-tests.py --impl "YOUR-COMMAND" --progress`.

**[Section 1: Reading](01-reading/README.md)** (`--read`)

- [ ] 1.1 Empty file
- [ ] 1.2 Integers
- [ ] 1.3 Signed integers
- [ ] 1.4 Booleans
- [ ] 1.5 Symbols
- [ ] 1.6 Symbols that don't start with a letter
- [ ] 1.7 Whitespace and comments
- [ ] 1.8 Characters
- [ ] 1.9 Named characters
- [ ] 1.10 Strings
- [ ] 1.11 String escapes
- [ ] 1.12 Lists
- [ ] 1.13 Nested lists
- [ ] 1.14 Dotted pairs
- [ ] 1.15 Abbreviations
- [ ] 1.16 Read errors (1/2)
- [ ] 1.17 Read errors (2/2)

**[Section 2: Evaluating data](02-evaluating-data/README.md)** (`--print`)

- [ ] 2.1 Self-evaluating data
- [ ] 2.2 quote
- [ ] 2.3 Variables
- [ ] 2.4 Malformed quote

**[Section 3: Calling primitives](03-calling-primitives/README.md)** (`--print`)

- [ ] 3.1 Addition and subtraction
- [ ] 3.2 Multiplication and division
- [ ] 3.3 Nested calls
- [ ] 3.4 Comparison
- [ ] 3.5 Type predicates
- [ ] 3.6 Characters and code points
- [ ] 3.7 Runtime errors: types
- [ ] 3.8 Runtime errors: calls

**[Section 4: Pairs](04-pairs/README.md)** (`--print`)

- [ ] 4.1 cons, car, and cdr
- [ ] 4.2 pair? and the empty list
- [ ] 4.3 Identity with eq?
- [ ] 4.4 Runtime errors: pairs

**[Section 5: Characters and I/O](05-characters-and-io/README.md)** (run (plain `IMPL FILE...`))

- [ ] 5.1 Writing characters
- [ ] 5.2 Run mode
- [ ] 5.3 Reading characters
- [ ] 5.4 peek-char and end of input
- [ ] 5.5 Runtime errors: I/O

**[Section 6: Conditionals](06-conditionals/README.md)** (`--print`)

- [ ] 6.1 if
- [ ] 6.2 Truthiness
- [ ] 6.3 if without an alternative
- [ ] 6.4 Only one branch runs
- [ ] 6.5 Reacting to input
- [ ] 6.6 Malformed if

**[Section 7: Variables](07-variables/README.md)** (`--print`)

- [ ] 7.1 define
- [ ] 7.2 Redefinition and order
- [ ] 7.3 set!
- [ ] 7.4 Primitives are variables
- [ ] 7.5 Identity through variables
- [ ] 7.6 Remembering input
- [ ] 7.7 Runtime errors: variables

**Coming next**

- Section 8: Procedures
- Section 9: Sequencing
- Section 10: Strings and symbols
- Section 11: Mutation and vectors
- Section 12: Tail calls
- Section 13: Errors
- Section 14: Macros
- Section 15: Continuations
- Section 16: Capstone

There are currently 51 stages with 207 tests.

## Harness modes

Seed itself only produces output through `write-char` (spec §4.5). To let early stages test reading and evaluation before any procedure exists, the harness asks your interpreter to support two extra modes, as an extension (spec §11.3):

| Invocation | Behaviour |
|---|---|
| `IMPL --read FILE...` | Read each datum from the files in order, and print it in the output format below, followed by a newline. Nothing is evaluated. |
| `IMPL --print FILE...` | Evaluate each top-level form in order, as a normal program would. After each one, if its value is not the unspecified value, print it in the output format below, followed by a newline. |
| `IMPL FILE...` | Run the program normally (spec §4.5). Standard output contains only what `write-char` writes. |

In every mode, a signaled error means: write a diagnostic to standard error, stop, and exit with a non-zero status. Everything printed before the error must still reach standard output.

### Output format

| Value | Printed as | Examples |
|---|---|---|
| integer | decimal, with `-` if negative | `42` `-7` |
| boolean | `#t` or `#f` | |
| symbol | its name, exactly as written | `foo` `list->string` `+` |
| string | in double quotes; `\`, `"`, newline, and tab printed as `\\`, `\"`, `\n`, and `\t`; every other character printed as itself | `"say \"hi\"\n"` |
| character | `#\` then the character, except `#\space`, `#\newline`, and `#\tab` | `#\a` `#\(` `#\space` |
| empty list | `()` | |
| pair | the shortest list form, with single spaces between elements and ` . ` before a non-list tail | `(1 2 3)` `(a . b)` `(1 2 . 3)` |
| quote forms | as ordinary lists, never as abbreviations | `(quote a)` |
| vector | `#(` elements `)` | `#(1 2)` |
| procedure | `#<procedure>` (primitives, closures, and continuations alike) | |
| eof object | `#<eof>` | |
| unspecified value | `#<unspecified>` when nested inside a printed value; at top level in `--print` mode it is not printed at all | |

Symbols from `gensym` have implementation-defined names, so no test prints one.

## Running the tests

The runner needs only Python 3. From the repository root:

```sh
./run-tests.py --impl "./my-seed"              # every stage
./run-tests.py --impl "python3 seed.py" 1      # section 1
./run-tests.py --impl "./my-seed" 2.3          # stage 2.3
./run-tests.py --impl "./my-seed" --upto 2.3   # every stage up to 2.3
./run-tests.py --impl "./my-seed" --progress   # one line per stage, plus spec status
SEED_IMPL="./my-seed" ./run-tests.py 1.4       # implementation via the environment
```

`--impl` is the command that runs your interpreter. The runner adds the mode flag (if any) and the file paths. Use `--upto` as you go, so an earlier stage can't quietly break.

## Test format

Each stage is a directory holding `stage.json` and its tests:

| File | Meaning |
|---|---|
| `NAME.scm` | The program. |
| `NAME.out` | Expected standard output, byte for byte. Missing means "expect no output". |
| `NAME.in` | Fed to standard input. Missing means empty input. |
| `stage.json` | The stage's title, its harness mode, and per-test options. |

Per-test options in `stage.json`:

| Option | Meaning |
|---|---|
| `"mode": "read"`/`"print"`/`"run"` | Override the stage's mode for this test. |
| `"expect": "error"` | The program must signal an error: non-zero exit status and a non-empty standard error. Standard output must still match `NAME.out`. |
| `"stdout": "ignore"` | Don't compare standard output. |
| `"load": [PATH, ...]` | Pass these files (relative to the stage) before the test file, as earlier files of the same program. |
| `"timeout": SECONDS` | Override the per-test timeout. |

Every test uses only features from its own stage and earlier ones. No test depends on behaviour the spec leaves unspecified, such as the order in which operands are evaluated.

## Spec coverage

Which stages test each section of the spec, and the section of this course that completes it.

| Spec section | Tested in stages | Completed in section |
|---|---|---|
| §2 Lexical syntax | 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 1.10, 1.11, 1.12, 1.13, 1.14, 1.15, 1.16, 1.17 | 1 |
| §3.1 Disjoint types | 2.1, 4.2, 5.4 | 11 (coming) |
| §3.2 Truthiness | 6.2, 6.3 | 6 |
| §3.3 Integers | 3.2 | 3 |
| §3.4 Characters and strings | — | 10 (coming) |
| §4.1 Programs | 2.1, 5.2, 7.2 | 7 |
| §4.2 Environments and variables | 2.3, 7.1, 7.4 | 8 (coming) |
| §4.5 Process interface | 1.1, 5.1, 5.2, 5.3 | 13 (coming) |
| §5.1 Variable reference | 2.3, 7.5, 7.7 | 7 |
| §5.2 Procedure call | 3.1, 3.3, 3.8 | 3 |
| §5.3 quote | 2.2, 2.4 | 2 |
| §5.4 if | 6.1, 6.3, 6.4, 6.5, 6.6 | 6 |
| §5.5 lambda | — | 9 (coming) |
| §5.6 define | 7.1, 7.2, 7.6, 7.7 | 9 (coming) |
| §5.7 set! | 7.3, 7.4, 7.7 | 7 |
| §5.8 begin | — | 9 (coming) |
| §6 Macros | — | 14 (coming) |
| §7 Proper tail recursion | — | 12 (coming) |
| §8 Continuations | — | 15 (coming) |
| §9.1 Pairs | 4.1, 4.4 | 11 (coming) |
| §9.2 Type predicates | 3.5, 4.2, 5.4 | 11 (coming) |
| §9.3 Identity | 4.3, 7.5 | 4 |
| §9.4 Integer primitives | 3.1, 3.2, 3.4, 3.7, 3.8 | 3 |
| §9.5 Characters | 3.6, 3.7, 3.8 | 3 |
| §9.6 Strings and symbols | — | 14 (coming) |
| §9.7 Vectors | — | 11 (coming) |
| §9.8 Control | — | 15 (coming) |
| §9.9 Input and output | 5.1, 5.3, 5.4, 5.5, 6.5, 7.6 | 5 |
| §10 Errors | 1.16, 1.17, 2.3, 2.4, 3.7, 3.8, 4.4, 5.5, 6.6, 7.7 | 13 (coming) |
| §11 Conformance | — | 16 (coming) |

Not tested, because no program can observe them:

- **§3.5** Literal constants: mutating a literal "is an error", which implementations need not detect.
- **§3.6** The unspecified value: by definition, programs cannot observe what it is.
- **§4.3** Reserved keywords: rebinding a keyword "is an error", which implementations need not detect.
- **§4.4** Evaluation order: unspecified. The tests are written so that they don't depend on it.
