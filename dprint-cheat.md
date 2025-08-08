# `dprint` Configuration

Use the file `dprint.json` in this directory as a template. It can be
recreated with `print init` which presents a pick list of file types
to support.

| command                     | notes                                                    |
| --------------------------- | -------------------------------------------------------- |
| `dprint init`               | Create a bare `dprint.json`.                             |
| `dprint check`              | List files that won't be formatted.                      |
| `dprint fmt`                | Format eligible files in place.                          |
| `dprint fmt {filename}`     | Format a specific file by name or glob                   |
| `dprint fmt --stdin {type}` | Read `stdin` treating it as {type} and write to `stdout` |

An example of the configuration in Helix's `languages.toml`.

```toml
formatter = { command = "dprint", args = ["fmt", "--stdin", "md"], auto-format = true }
```
