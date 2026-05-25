# configs

Personal dotfiles — orange-themed tmux, zsh, and neovim with smooth visual transitions.

## Layout

```
configs/
├── bash/.bashrc
├── zsh/.zshrc
├── tmux/.tmux.conf
└── nvim/nvim/        ← this is the dir that becomes ~/.config/nvim
    ├── init.lua
    └── lua/user/…
```

See [`ALIASES.md`](./ALIASES.md) for the zsh aliases this repo adds.

## Install

### 1. Clone this repo

```sh
git clone <repo-url> ~/configs
cd ~/configs
```

### 2. Install oh-my-zsh + plugins

```sh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions     ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 3. Install fzf

```sh
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### 4. Link the dotfiles + install nvim requirements

From inside the repo:

```sh
./install.sh
```

`install.sh` does two things:

**a) Symlinks dotfiles**

| Repo file                          | → Target                |
| ---------------------------------- | ----------------------- |
| `bash/.bashrc`                     | `~/.bashrc`             |
| `zsh/.zshrc`                       | `~/.zshrc`              |
| `tmux/.tmux.conf`                  | `~/.tmux.conf`          |
| `nvim/nvim`                        | `~/.config/nvim`        |

Any existing target is moved aside to `<path>.backup-<timestamp>` before the symlink is created — nothing is overwritten silently. Re-running is safe; already-correct links are skipped.

**b) Installs nvim plugin requirements**

- `ripgrep` — Telescope live-grep, the `rgf` alias
- `fd` — faster file picker for the `f` alias
- JetBrains Mono Nerd Font — icons in nvim-tree, bufferline, lualine, the dashboard

On macOS these are installed automatically via `brew`. On Linux (apt/dnf/pacman) the script prints the install command for you to run with the privileges your distro requires — it never escalates on your behalf.

Skip the dependency step with `./install.sh --no-deps`.

### 5. Open nvim

`lazy.nvim` bootstraps on first launch and installs every plugin defined in `init.lua` automatically. After that, point your terminal at JetBrains Mono Nerd Font (or any Nerd Font) so icons render correctly.
