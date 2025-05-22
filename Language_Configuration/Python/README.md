# My Python Source Style

From `PEP8` via `pycodestyle`:

    A style guide is about consistency. Consistency with this style guide
    is important. Consistency within a project is more important.
    Consistency within one module or function is most important.

I'm aware of Python's preferred standards but I don't agree with them. I do
agree that consistency within a code base or organization is important. I've
created a setup that works for me. You probably won't like it, and I don't
encourage anyone to use it.

An auto formatter fixes almost every "violation" I make while editing code. I
don't get too worried about missing a space around an operator and let the
tools fix such things. Many of my apparent deviation from the accepted standard
are there to avoid noise warnings while editing code.

An auto formatter will fix these violations so I don't care to see them.

If I'm working in a foreign code base, I will adhere to its standards. That
avoids trash diffs and it's the right thing to do.

## `pylsp` Configuration

I'm using Neovim with `pylsp` as my language server with the following
plugins enabled:

| Tool        | Description                                         |
| ----------- | --------------------------------------------------- |
| pyflakes    | Does not check style, but finds some code errors    |
| pycodestyle | Configurable source style checker starts from PEP 8 |
| pydocstyle  | Doc string style checker based on PEP 257           |
| mccabe      | Function complexity warnings                        |

So far, I've only had to create a configuration file for `pycodestyle`
and adjust the settings in my `.editorconfig` to smooth my editing
experience.

## `.editorconfig` Settings

I have just two unusual settings for Python:

    indent_style = tab
    indent_size = 3

## `pycodestyle` Exclusions

I have a very few outright violations of PEP-8 ignored, but most of the items
ignored below are noise warnings that are distracting while editing.

And what kind of configuration file doesn't accept comments?

I mean really.

### Egregious Violations

```
E111 Indentation is not a multiple of four
E128 Continuation line under-indented for visual indent
W191 Indentation contains tabs.
```

Indents should use tabs. See Rob Pike, the Go Language, and others for
justification. I'm not using proportional fonts, but if I did tabs would be
even more important.

Visually I find four spaces per tab too wide and two spaces per tab too narrow.
Three is the Goldilocks zone.

Formatters for Python have difficulty with alignment on continuation. Since I'm
already going against the grain, I'll just accept what the formatters do once
I've set indents and tab-width as I like them and turned off noise messages
that formatting will fix.

### White Space

#### Horizontal White Space

```
E231 Missing whitespace after ,;:
E251 Unexpected spaces around keyword/parameter
E261 At least two spaces before inline comment
W291 Trailing whitespace.
W293 Blank line contains whitespace.
```

`yapf` fixes these.

#### Vertical White Space

```
E301 Various misplaced or miscounted blank lines
E302
E303
E304
E305
E306
```

`yapf` fixes these.

#### Line Length

```
E501 Line too long.
W505 Doc line too long.
```

`yapf` fixes these.

### Line Break or Continuation

```
W503 Line break before binary operator.
W504 Line break after binary operator.
```

I can't get `yapf` to reliably break -after- a binary operator, which in my
opinion is the correct way to do it. `yapf` will do what it does and I'll
ignore these warnings.

## `yapf` Configuration

In Neovim I am using `none-ls` to automatically format on save. I looked
at `black`, `blue`, `ruff`, and a few others. `blue` had the best functionality for
my use but it looks dormant. Google's `yapf` can be configured to match
my Python standards.

    continuation_align_style = fixed
    coalesce_brackets = true
    dedent_closing_brackets = true
    use_tabs = true
    indent_width = 3
