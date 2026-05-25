# New zsh aliases & functions

Quality-of-life additions in `zsh/.zshrc`. Everything else (your `radiance`, `sp25`, `sim`, `gen`, `vim=nvim`, etc.) is untouched.

## Navigation & `ls`

| Alias / fn  | Expands to       | What it does                              |
| ----------- | ---------------- | ----------------------------------------- |
| `ll`        | `ls -lh`         | Long listing, human sizes                 |
| `la`        | `ls -lAh`        | Long listing including dotfiles           |
| `lt`        | `ls -lAhtr`      | Sorted by mtime — newest at the bottom    |
| `..`        | `cd ..`          | Up one dir                                |
| `...`       | `cd ../..`       | Up two                                    |
| `....`      | `cd ../../..`    | Up three                                  |
| `mkcd <d>`  | function          | `mkdir -p <d> && cd <d>`                  |

## Git

| Alias  | Expands to      | Notes                                    |
| ------ | --------------- | ---------------------------------------- |
| `ga`   | `git add`       |                                          |
| `gc`   | `git commit`    |                                          |
| `gca`  | `git commit -a` | Auto-stage tracked files                 |
| `gp`   | `git push`      |                                          |
| `gpl`  | `git pull`      |                                          |
| `gco`  | `git checkout`  | e.g. `gco main`, `gco -b feature/x`      |
| `gd`   | `git diff`      |                                          |
| `gb`   | `git branch`    |                                          |

Pre-existing (kept): `gt` (graph log), `gs` (status), `gl` (log).

## tmux

| Alias / fn  | Expands to              | Notes                                     |
| ----------- | ----------------------- | ----------------------------------------- |
| `ta`        | `tmux attach`           | Attach to last session                    |
| `tl`        | `tmux list-sessions`    |                                           |
| `tn <name>` | function                | New named session, or attach if it exists |

Pre-existing (kept): `t <name>` — attach to a named session.

## fzf-powered finders

Both use the orange fzf theme set in `FZF_DEFAULT_OPTS`.

| Function          | What it does                                                                   |
| ----------------- | ------------------------------------------------------------------------------ |
| `f [path]`        | fzf file picker (uses `fd` if available, else `find`); opens choice in $EDITOR |
| `rgf [query]`     | Live ripgrep + fzf; opens the match in $EDITOR at the right line               |

`rgf` requires `rg` (ripgrep). `f`'s preview shows the first 200 lines of each candidate.
