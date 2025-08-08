# `ripgrep` Cheat Sheet

## Default Behaviors

By default `ripgrep` will: 

- Honor your `.gitignore` settings.
- Checks for additional ignore directives in `.ignore`.
- Does not process hidden files or directories.
- Does not follow symlinks.

## Useful command line arguments

These are the arguments I'm most likely to use.

- `-h` for brief help.
- `--help` for complete help.
- `-i` for case insensitive searches.
- `-S` for smart case searches as in editors.
- `-F` to search for a string instead of a regular expression.
- `-w` to treat the search string as if it was bracketed by `\b`.
- `-g` for file globs to accept or reject(!).
- `-.` to include hidden files in the search.
- `-L` to follow symbolic links.
- `-M=###` clips large lines to show ### columns.
- `-max-columns-preview` with above shows a preview.
- `-C` show the context around the match.
- `-c` prints the names of files with matches and the number of matches in each file.
- `--type {type}` to search only files of a type.
- `--type-not {type}` to exclude files of a type.
- `--type-list` to see type to extension mappings.
- `--stats` for analysis of your search.

## Search Strings

By default the search string is evaluated as a regular expression. 
Normal shell conventions for quoting to avoid globbing work as
expected.

```sh
$ ls
README.md
README.txt
readme.md

$ ls >bogus.txt

$ # search is a file glob:
$ rg readme.*
bogus.txt: readme.md

$ # search is a regular expression with globbing inhibited:
$ rg 'README.*'
bogus.txt: README.md
bogus.txt: README.txt

$ # search for a literal splat in golang files:
$ rg -F '*' --type go
...
```

## Configuration

A configuration at `~/.ripgreprc` of the one argument or
value per line format can override defaults if you do not
like the builtin defaults.

This will make searches case insensitive and adds a new
filetype. 

File `.ignore`:
```sh
-i
--type-add
'purebasic:*.{pb,pbi}'
```
