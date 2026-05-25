#!/usr/bin/env bash
# Symlink dotfiles in this repo to their conventional locations under $HOME.
# Existing files/dirs at the target are moved to <path>.backup-<timestamp>.

set -euo pipefail

REPO="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STAMP="$(date +%Y%m%d-%H%M%S)"

# repo-path → home-path
links=(
  "$REPO/bash/.bashrc        $HOME/.bashrc"
  "$REPO/zsh/.zshrc          $HOME/.zshrc"
  "$REPO/tmux/.tmux.conf     $HOME/.tmux.conf"
  "$REPO/nvim/nvim           $HOME/.config/nvim"
)

orange() { printf '\033[38;5;208m%s\033[0m' "$*"; }
dim()    { printf '\033[38;5;240m%s\033[0m' "$*"; }
have()   { command -v "$1" >/dev/null 2>&1; }

# ----- nvim plugin requirements -----------------------------------
# Best-effort install of ripgrep, fd, and a Nerd Font via the system
# package manager. Already-installed tools are skipped. If no
# supported package manager is detected, prints hints and continues.
install_deps() {
  echo
  echo "$(orange '❯') Installing nvim plugin requirements"
  echo

  if have brew; then
    _install_brew
  elif have apt-get; then
    _install_apt
  elif have dnf; then
    _install_dnf
  elif have pacman; then
    _install_pacman
  else
    echo "  $(orange '!') no supported package manager found (brew/apt/dnf/pacman)"
    echo "  $(dim 'install manually:') ripgrep, fd-find, a Nerd Font"
    return
  fi
}

_install_brew() {
  for pkg in ripgrep fd; do
    if have "$pkg" || ( [[ $pkg == fd ]] && have fdfind ); then
      echo "  $(orange '✓') $pkg already installed"
    else
      echo "  $(orange '↓') brew install $pkg"
      brew install "$pkg" >/dev/null
    fi
  done
  # JetBrains Mono Nerd Font (any Nerd Font works — this is a sensible default)
  if brew list --cask 2>/dev/null | grep -q '^font-jetbrains-mono-nerd-font$'; then
    echo "  $(orange '✓') font-jetbrains-mono-nerd-font already installed"
  else
    echo "  $(orange '↓') brew install --cask font-jetbrains-mono-nerd-font"
    brew install --cask font-jetbrains-mono-nerd-font >/dev/null \
      || echo "  $(orange '!') font install failed — install a Nerd Font manually from nerdfonts.com"
  fi
}

# For Linux package managers we print the command for you to run
# yourself (most need elevated privileges) — this script never escalates.
_install_apt() {
  local need=()
  have rg     || need+=(ripgrep)
  have fd     || have fdfind || need+=(fd-find)
  if (( ${#need[@]} )); then
    echo "  $(orange '!') missing: ${need[*]}"
    echo "  $(dim 'run:') apt-get install -y ${need[*]}"
  else
    echo "  $(orange '✓') ripgrep + fd already installed"
  fi
  echo "  $(dim 'Nerd Font:') download from https://www.nerdfonts.com/ and configure your terminal"
}

_install_dnf() {
  local need=()
  have rg || need+=(ripgrep)
  have fd || need+=(fd-find)
  if (( ${#need[@]} )); then
    echo "  $(orange '!') missing: ${need[*]}"
    echo "  $(dim 'run:') dnf install -y ${need[*]}"
  else
    echo "  $(orange '✓') ripgrep + fd already installed"
  fi
  echo "  $(dim 'Nerd Font:') download from https://www.nerdfonts.com/ and configure your terminal"
}

_install_pacman() {
  local need=()
  have rg || need+=(ripgrep)
  have fd || need+=(fd)
  if (( ${#need[@]} )); then
    echo "  $(orange '!') missing: ${need[*]}"
    echo "  $(dim 'run:') pacman -S --needed ${need[*]}"
  else
    echo "  $(orange '✓') ripgrep + fd already installed"
  fi
  echo "  $(dim 'Nerd Font:') pacman -S ttf-jetbrains-mono-nerd  (or any Nerd Font of choice)"
}

# Allow opting out: ./install.sh --no-deps
SKIP_DEPS=0
for arg in "$@"; do
  [[ "$arg" == "--no-deps" ]] && SKIP_DEPS=1
done

echo
echo "$(orange '❯') Linking dotfiles from $(dim "$REPO")"
echo

mkdir -p "$HOME/.config"

for entry in "${links[@]}"; do
  # shellcheck disable=SC2086
  set -- $entry
  src="$1"
  dst="$2"

  if [[ ! -e "$src" ]]; then
    echo "  $(orange '!') skipping $(dim "$src") — source missing"
    continue
  fi

  # Already pointing where we want? Leave it alone.
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "  $(orange '✓') $(dim "$dst") already linked"
    continue
  fi

  # Back up anything that's in the way (file, dir, or stale symlink).
  if [[ -e "$dst" || -L "$dst" ]]; then
    backup="${dst}.backup-${STAMP}"
    mv "$dst" "$backup"
    echo "  $(orange '↺') backed up $(dim "$dst") → $(dim "$backup")"
  fi

  ln -s "$src" "$dst"
  echo "  $(orange '→') $(dim "$dst") → $src"
done

if (( SKIP_DEPS == 0 )); then
  install_deps
fi

echo
echo "$(orange '✓') done."
echo "$(dim '  open nvim and lazy.nvim will install plugins automatically.')"
