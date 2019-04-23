# Contributing

This document, stolen from the Neofetch repository, describes the code style required when contributing to Winfetch.

- [Coding Conventions](#coding-conventions)
  - [Clauses](#code-clauses)

### Coding Conventions

- **No using PowerShell aliases.** Please.
- Use .NET functions where possible.
    - **exception**: `write-host` instead of `console.writeline()`
- Don't throw exceptions. 
    - Intead, write the error message in `red` and terminate (`exit 1`).
- Indent 4 spaces.
- Use [snake_case](https://en.wikipedia.org/wiki/Snake_case) for function
  and variable names.
- Try to keep lines below `128` characters long.
- Use lowercase for .NET functions where possible.
    - e.g. `[text.encoding]::utf8.getstring((000,000,000))` instead of `[Text.Encoding]::UTF8.GetString((000,000,000))`.

Also, **please test out your changes** before submitting a PR.

#### Code Clauses
Do not put the `else/elseif` clause on a separate line:
```powershell
if ($condition) {

}
else {}                # BAD

if ($condition) {

} else {

}                      # GOOD

if ($condition) {}
else {}                # THIS IS OK
```