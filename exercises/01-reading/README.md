# Section 1: Reading

Your interpreter's first job is to turn program text into data. In this section nothing is evaluated: in `--read` mode, your interpreter reads each datum in the file and prints it back in the standard output format. You'll need that printer for the rest of the course, so it's worth building carefully.

**Mode:** `--read` for every test in this section.

## Unlocks

Completing this section **unlocks**: §2 Lexical syntax.

It also contributes to: §4.5 Process interface (completed in section 13), §10 Errors (completed in section 13).

## Stages

- [ ] [1.1 Empty file](#11-empty-file)
- [ ] [1.2 Integers](#12-integers)
- [ ] [1.3 Signed integers](#13-signed-integers)
- [ ] [1.4 Booleans](#14-booleans)
- [ ] [1.5 Symbols](#15-symbols)
- [ ] [1.6 Symbols that don't start with a letter](#16-symbols-that-dont-start-with-a-letter)
- [ ] [1.7 Whitespace and comments](#17-whitespace-and-comments)
- [ ] [1.8 Characters](#18-characters)
- [ ] [1.9 Named characters](#19-named-characters)
- [ ] [1.10 Strings](#110-strings)
- [ ] [1.11 String escapes](#111-string-escapes)
- [ ] [1.12 Lists](#112-lists)
- [ ] [1.13 Nested lists](#113-nested-lists)
- [ ] [1.14 Dotted pairs](#114-dotted-pairs)
- [ ] [1.15 Abbreviations](#115-abbreviations)
- [ ] [1.16 Read errors (1/2)](#116-read-errors-12)
- [ ] [1.17 Read errors (2/2)](#117-read-errors-22)

---

## 1.1 Empty file

**Spec:** §4.5 Process interface

Implement support for:

- Running `IMPL --read FILE...` on empty files: print nothing and exit with status 0.
- Accepting several files in one run.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.1`

| Test | Checks | Expects |
|---|---|---|
| [`empty`](01-empty-file/empty.scm) | a zero-byte file | no output |
| [`newline-only`](01-empty-file/newline-only.scm) | a file containing only a newline | no output |
| [`two-files`](01-empty-file/two-files.scm) | two empty files in one run | no output (several files) |

---

## 1.2 Integers

**Spec:** §2 Lexical syntax

Implement support for:

- Reading unsigned decimal integers and printing them back.
- Files containing several data, one per line.

> **Note:** Until stage 1.7, test files separate data with newlines only.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.2`

| Test | Checks | Expects |
|---|---|---|
| [`single`](02-integers/single.scm) | one integer | output |
| [`several`](02-integers/several.scm) | one integer per line | output |
| [`leading-zeros`](02-integers/leading-zeros.scm) | leading zeros are not part of the value | output |
| [`large`](02-integers/large.scm) | integers up to 2^29 - 1 | output |

---

## 1.3 Signed integers

**Spec:** §2 Lexical syntax

Implement support for:

- Integers with a leading `-` or `+`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.3`

| Test | Checks | Expects |
|---|---|---|
| [`negative`](03-signed-integers/negative.scm) | negative integers | output |
| [`plus`](03-signed-integers/plus.scm) | a leading + is accepted and not printed | output |
| [`negative-zero`](03-signed-integers/negative-zero.scm) | -0 is zero | output |
| [`range`](03-signed-integers/range.scm) | the minimum required range | output |

---

## 1.4 Booleans

**Spec:** §2 Lexical syntax

Implement support for:

- The booleans `#t` and `#f`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.4`

| Test | Checks | Expects |
|---|---|---|
| [`true-false`](04-booleans/true-false.scm) | #t and #f | output |
| [`mixed`](04-booleans/mixed.scm) | booleans among integers | output |

---

## 1.5 Symbols

**Spec:** §2 Lexical syntax

Implement support for:

- Symbols that start with a letter, made of letters, digits, and punctuation such as `-`, `>`, `!`, and `?`.
- Symbols are case-sensitive: print them exactly as written.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.5`

| Test | Checks | Expects |
|---|---|---|
| [`simple`](05-symbols/simple.scm) | plain symbols | output |
| [`case`](05-symbols/case.scm) | case is preserved | output |
| [`punctuation`](05-symbols/punctuation.scm) | letters, digits, and punctuation | output |

---

## 1.6 Symbols that don't start with a letter

**Spec:** §2 Lexical syntax

Implement support for:

- Symbols such as `+`, `-`, `...`, `1+`, and `->x`.
- Telling integers and symbols apart: a token is an integer only if it is an optional sign followed by digits.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.6`

| Test | Checks | Expects |
|---|---|---|
| [`operators`](06-peculiar-symbols/operators.scm) | arithmetic and comparison names | output |
| [`others`](06-peculiar-symbols/others.scm) | other symbols | output |
| [`integer-or-symbol`](06-peculiar-symbols/integer-or-symbol.scm) | signs and digits | output |

---

## 1.7 Whitespace and comments

**Spec:** §2 Lexical syntax

Implement support for:

- Spaces, tabs, carriage returns, and form feeds between data, and several data on one line.
- Comments from `;` to the end of the line, including a comment at the end of a file with no final newline.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.7`

| Test | Checks | Expects |
|---|---|---|
| [`spaces`](07-whitespace/spaces.scm) | several data on one line | output |
| [`tabs-and-returns`](07-whitespace/tabs-and-returns.scm) | tabs and carriage returns | output |
| [`comments`](07-whitespace/comments.scm) | comments between data | output |
| [`comment-at-eof`](07-whitespace/comment-at-eof.scm) | a final comment with no newline | output |
| [`only-comments`](07-whitespace/only-comments.scm) | a file of comments | no output |

---

## 1.8 Characters

**Spec:** §2 Lexical syntax

Implement support for:

- Character literals `#\c` for any single visible character, including delimiters and prefixes such as `#\(`, `#\;`, `#\"`, and `#\\`.
- Printing a character as `#\` followed by the character.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.8`

| Test | Checks | Expects |
|---|---|---|
| [`letters`](08-characters/letters.scm) | letters and digits | output |
| [`punctuation`](08-characters/punctuation.scm) | delimiters and prefixes | output |
| [`mixed`](08-characters/mixed.scm) | characters among other data | output |

---

## 1.9 Named characters

**Spec:** §2 Lexical syntax

Implement support for:

- The character names `space`, `newline`, and `tab`.
- A literal space after `#\`.
- Printing those three characters by name.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.9`

| Test | Checks | Expects |
|---|---|---|
| [`names`](09-named-characters/names.scm) | the three required names | output |
| [`literal-space`](09-named-characters/literal-space.scm) | #\ followed by a space | output |
| [`case`](09-named-characters/case.scm) | single characters are still case-sensitive | output |

---

## 1.10 Strings

**Spec:** §2 Lexical syntax

Implement support for:

- String literals in double quotes, including the empty string and strings containing delimiters.
- Printing a string in double quotes.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.10`

| Test | Checks | Expects |
|---|---|---|
| [`simple`](10-strings/simple.scm) | a string | output |
| [`empty`](10-strings/empty.scm) | the empty string | output |
| [`delimiters`](10-strings/delimiters.scm) | delimiters inside a string | output |
| [`several`](10-strings/several.scm) | several strings on a line | output |

---

## 1.11 String escapes

**Spec:** §2 Lexical syntax

Implement support for:

- The escapes `\\`, `\"`, `\n`, and `\t`.
- String literals that span several lines.
- Printing those four characters as escapes.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.11`

| Test | Checks | Expects |
|---|---|---|
| [`quote-and-backslash`](11-string-escapes/quote-and-backslash.scm) | escaped quotes and backslashes | output |
| [`newline-and-tab`](11-string-escapes/newline-and-tab.scm) | escaped newlines and tabs | output |
| [`literal-newline`](11-string-escapes/literal-newline.scm) | a string spanning two lines | output |
| [`literal-tab`](11-string-escapes/literal-tab.scm) | a literal tab inside a string | output |

---

## 1.12 Lists

**Spec:** §2 Lexical syntax

Implement support for:

- Lists of data in parentheses, including the empty list.
- Printing a list with single spaces between elements.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.12`

| Test | Checks | Expects |
|---|---|---|
| [`empty`](12-lists/empty.scm) | the empty list | output |
| [`flat`](12-lists/flat.scm) | flat lists | output |
| [`mixed`](12-lists/mixed.scm) | lists of mixed types | output |
| [`spacing`](12-lists/spacing.scm) | irregular spacing inside a list | output |
| [`adjacent`](12-lists/adjacent.scm) | lists with no space between them | output |

---

## 1.13 Nested lists

**Spec:** §2 Lexical syntax

Implement support for:

- Lists inside lists, to any depth.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.13`

| Test | Checks | Expects |
|---|---|---|
| [`nested`](13-nested-lists/nested.scm) | lists of lists | output |
| [`deep`](13-nested-lists/deep.scm) | deep nesting | output |
| [`empty-lists`](13-nested-lists/empty-lists.scm) | lists of empty lists | output |

---

## 1.14 Dotted pairs

**Spec:** §2 Lexical syntax

Implement support for:

- Dotted lists `(a . b)` and `(a b . c)`.
- Printing pairs in the shortest form: `(1 . (2 . ()))` prints as `(1 2)`.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.14`

| Test | Checks | Expects |
|---|---|---|
| [`pair`](14-dotted-pairs/pair.scm) | a dotted pair | output |
| [`improper`](14-dotted-pairs/improper.scm) | an improper list | output |
| [`normalize`](14-dotted-pairs/normalize.scm) | dotted notation that forms a proper list | output |
| [`nested`](14-dotted-pairs/nested.scm) | pairs inside pairs | output |
| [`spacing`](14-dotted-pairs/spacing.scm) | whitespace around the dot | output |

---

## 1.15 Abbreviations

**Spec:** §2 Lexical syntax

Implement support for:

- The prefixes `'`, `` ` ``, `,`, and `,@`, read as `(quote d)`, `(quasiquote d)`, `(unquote d)`, and `(unquote-splicing d)`.
- Printing these forms as lists (not as abbreviations).

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.15`

| Test | Checks | Expects |
|---|---|---|
| [`quote`](15-abbreviations/quote.scm) | the quote prefix | output |
| [`quasiquote`](15-abbreviations/quasiquote.scm) | quasiquote, unquote, and unquote-splicing | output |
| [`nested`](15-abbreviations/nested.scm) | abbreviations of abbreviations | output |
| [`spacing`](15-abbreviations/spacing.scm) | whitespace after a prefix | output |
| [`inside-lists`](15-abbreviations/inside-lists.scm) | abbreviations inside a list | output |

---

## 1.16 Read errors (1/2)

**Spec:** §2 Lexical syntax, §10 Errors

Implement support for:

- Signaling an error for unbalanced parentheses and unterminated strings: write a diagnostic to standard error and exit with a non-zero status.

> **Note:** For read errors the tests check only the exit status and standard error, not standard output, because the spec doesn't fix whether earlier data are printed first.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.16`

| Test | Checks | Expects |
|---|---|---|
| [`unclosed`](16-read-errors-1/unclosed.scm) | a list that is never closed | error |
| [`unclosed-nested`](16-read-errors-1/unclosed-nested.scm) | a nested list that is never closed | error |
| [`stray-close`](16-read-errors-1/stray-close.scm) | a close parenthesis with no open | error |
| [`extra-close`](16-read-errors-1/extra-close.scm) | one close parenthesis too many | error |
| [`unterminated-string`](16-read-errors-1/unterminated-string.scm) | a string that is never closed | error |

---

## 1.17 Read errors (2/2)

**Spec:** §2 Lexical syntax, §10 Errors

Implement support for:

- Signaling an error for a misplaced dot, an unknown character name, an unknown string escape, unknown `#` syntax, and a prefix with no datum after it.

Run: `./run-tests.py --impl "YOUR-COMMAND" 1.17`

| Test | Checks | Expects |
|---|---|---|
| [`dot-first`](17-read-errors-2/dot-first.scm) | a dot with nothing before it | error |
| [`dot-empty`](17-read-errors-2/dot-empty.scm) | a dot with nothing after it | error |
| [`dot-two-tails`](17-read-errors-2/dot-two-tails.scm) | two data after a dot | error |
| [`dot-alone`](17-read-errors-2/dot-alone.scm) | a dot outside a list | error |
| [`bad-char-name`](17-read-errors-2/bad-char-name.scm) | an unknown character name | error |
| [`bad-escape`](17-read-errors-2/bad-escape.scm) | an unknown string escape | error |
| [`bad-hash`](17-read-errors-2/bad-hash.scm) | unknown # syntax | error |
| [`prefix-at-eof`](17-read-errors-2/prefix-at-eof.scm) | a quote prefix at the end of the file | error |
