# LLDB Quick Reference

A quick command reference for using LLDB from the command line with Free Pascal on macOs.

## Notes

1. Unless prefixed with `$` all commands are from the `(lldb)` prompt.
1. `LLDB` supports many `GDB` commands as synonyms. `GDB` is terse while `LLDB` is verbose and explicit. Its syntax reminds me of `Powershell`.
1. In spite of that, many commands and flags can be abbreviated.
1. Referencing code locations is "module-or-filename`symbol-name". While Pascal is not case-sensitive, symbol names maintain their declaration casing.
1. When referencing variables or dynamically loaded code, the application must have run far enough to allocate the variable. Globals can usually be done after hitting your program's entry point. Locals require making it to a function's entry point.

## Terminology

Programs are targets. When loaded they are part of an image.

## Note on special characters

LLDB uses the grave accent &#96; as a delimiter character. Some calculations are enclosed within them and act as a separator between names (program &#96; function). Markdown uses these to mark program code text. When you see something like `b program'main` read the apostrophe as a grave accent.

## The big list

I had these broken out by general task but that looked rather forced. Now I just list everything in one big table in what I hope is a useful functional order.

| If you want to            | Do this                                      |
| ------------------------- | -------------------------------------------- |
|                           | <br>                                         |
| debug a program           | `$ lldb program`                             |
| with persistent arguments | `$ lldb -- program args...`                  |
|                           | <br>                                         |
| from within lldb          | `file pathToProgram`                         |
|                           | `attach -p #`                                |
|                           | `process attach --name`                      |
|                           | `process attach --name whatever --waitfor`   |
|                           | <br>                                         |
| begin program             | `run`                                        |
| with transient arguments  | `r args...`                                  |
| with persistent arguments | `process launch -- args...`                  |
| set or modify arguments   | `settings show target.run-args`              |
|                           | <br>                                         |
| run on another terminal   | `process launch --tty -- args...`            |
|                           | `process launch --tty /dev/ttys6 -- args...` |
|                           | <br>                                         |
| set or modify environment | `settings set target.env-vars DEBUG=1`       |
| variables                 | `env DEBUG=1`                                |
|                           | `settings remove target.env-vars DEBUG`      |
|                           | `set rem target.env-vars DEBUG`              |
|                           | <br>                                         |
| set breakpoints           | `b program'main` (that's a &#96;)            |
|                           | `breakpoint set program'main`                |
|                           | `br s program'init`                          |
| by source file line       | `b s -f test.pas -l 28`                      |
| all functions named main  | `b main`                                     |
|                           | <br>                                         |
| manage breakpoints        | `breakpoint list`                            |
|                           | `br l`                                       |
|                           | `breakpoint disable #`                       |
|                           | `br enable #`                                |
|                           | `breakpoint delete #`                        |
|                           | `br del #`                                   |
| conditional breakpoints   | `br mod -c "i < 0" #`                        |
|                           | `br mod -c "" #`                             |
|                           | <br>                                         |
| watchpoints               | `watchpoint set variable counter`            |
|                           | `watchpoint set expression -- a 'expr'`      |
|                           | `watchpoint list`                            |
|                           | <br>                                         |
| display stack trace       | `bt`                                         |
| switch to frame           | `f #`                                        |
| describe current frame    | `f info`                                     |
| move up or down stack     | `up`                                         |
|                           | `down`                                       |
|                           | <br>                                         |
| start                     | `r` or `process launch`                      |
| continue                  | `c` or `process continue`                    |
| step (in)                 | `s` or `step` or `thread step-in`            |
| step over                 | `n` or `next` or `thread step-over`          |
| step out                  | `f` or `finish` or `thread setp-out`         |
|                           | <br>                                         |
| examine state             | `register read`                              |
|                           | `register read rax`                          |
|                           | `register write rax 14`                      |
| globals                   | `target variable`                            |
| a specific global         | `target var x`                               |
| locals                    | `frame variable`                             |
| a specific local          | `frame var i j k`                            |
|                           | <br>                                         |
| main executable           | `image list`                                 |
| image symbols             | `image dump symtab`                          |
| in specific module        | `image dump symtab prognam`                  |
|                           | <br>                                         |

## Displaying variables or memory

Display variables or memory using:

- `print` or `dwim-print`
- `x` or `memory read`

The `x` command has more options than I expect to use. Use `help` for details. To specify an output format, the option is `-f ?` where `?` is one of the format abbreviations below. I don't know if all of these work with FPC.

- `x -f b doneYet` prints variable doneYet as a boolean.
- `p/x someWord` prints variable someWord in hexadecimal.

| name                 | abbreviation | comments                        |
| -------------------- | ------------ | ------------------------------- |
| default              |              | LLDB takes a guess              |
| boolean              | B            | 0 = false, anything else = true |
| binary               | b            |                                 |
| bytes                | y            |                                 |
| bytes with ASCII     | Y            |                                 |
| character            | c            |                                 |
| printable characters | C            |                                 |
| float                | f            |                                 |
| hex                  | x            |                                 |
| address              | A            |                                 |
| C string             | s            | 0 terminated                    |
| enumeration          | E            |                                 |
| unicode16            | U            | glyphs                          |
| unicode32            |              |                                 |
| decimal              | d            |                                 |
| unsigned decimal     | u            |                                 |
| char[]               | a            | characters                      |
| int#_t               |              | and the uint#_t C types         |

## Miscellany

- Expressions enclosed in backticks can be used: `$rax+0x1f8`.
