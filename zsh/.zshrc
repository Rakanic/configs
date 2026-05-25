# =========================
# Global config if present
# =========================
[[ -f /etc/zshrc ]] && source /etc/zshrc

# =========================
# User PATH
# =========================
case ":$PATH:" in
  *":$HOME/.local/bin:$HOME/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$HOME/bin:$PATH" ;;
esac

# =========================
# Oh My Zsh
# =========================
export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# =========================
# Conda
# =========================
__conda_setup="$('/bwrcq/home/nicorakela/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/bwrcq/home/nicorakela/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/bwrcq/home/nicorakela/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/bwrcq/home/nicorakela/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

# =========================
# Cargo
# =========================
. "$HOME/.cargo/env"

# =========================
# Aliases
# =========================
alias radiance='source /tools/C/ee290-fa24-2/ee290-env.sh && cd /tools/scratch/nicorakela/radiance-cy-dev && source env.sh && source /tools/C/ee194-sp26/bwrc-env.sh'
alias radiance2='source /tools/C/ee290-fa24-2/ee290-env.sh && cd /scratch/nicorakela/radiance-cy2 && source env.sh && source /tools/C/ee194-sp26/bwrc-env.sh'
alias sp25='source /tools/C/ee290-fa24-2/ee290-env.sh && cd /tools/scratch/nicorakela/sp25-chips/ && source env.sh && source /tools/C/ee194-sp26/bwrc-env.sh'
alias sp26='source /tools/C/ee290-fa24-2/ee290-env.sh && cd /tools/scratch/nicorakela/sp26-chip/ && source env.sh && source /tools/C/ee194-sp26/bwrc-env.sh'
alias mxgen='cd /scratch/nicorakela/MxGen && source /tools/commercial/flexlm/flexlm.sh && source /tools/flexlm/flexlm.sh'
alias bringup='cd /tools/scratch/nicorakela/sp25-Baremetal-IDE/ && source /tools/scratch/nicorakela/sp25-chips/env.sh && source /tools/C/ee290-fa24-2/ee290-env.sh && source /tools/commercial/flexlm/flexlm.sh && source /tools/commercial/xilinx/Vivado/2024.2/settings64.sh && source /tools/flexlm/flexlm.sh'
alias setupcy='./build-setup.sh --use-lean-conda -s 6 -s 7 -s 8 -s 9'
#alias nvim='/users/nicorakela/nvim-linux-x86_64/bin/nvim'

alias gt='git log --graph --decorate --oneline --all'
alias gs='git status'
alias gl='git log'
alias vcs='cd $CY_DIR/sims/vcs'
alias vim='nvim'
alias vi='nvim'

# ---- Nav + ls helpers ----
alias ll='ls -lh'
alias la='ls -lAh'
alias lt='ls -lAhtr'         # sorted by mtime, newest at bottom
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ---- Git shortcuts (don't shadow existing gt/gs/gl) ----
alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gd='git diff'
alias gb='git branch'

# ---- tmux shortcuts ----
alias ta='tmux attach'        # attach to last/most-recent session
alias tl='tmux list-sessions'

# =========================
# Functions
# =========================
sim() {
    vcs && make run-binary CONFIG="$1" BINARY="$CY_DIR/$2" LOADMEM=1
}

sim_dgb() {
    vcs && make run-binary-debug CONFIG="$1" BINARY="$CY_DIR/$2" LOADMEM=1
}

gen() {
    cd "$CY_DIR/generators/$1"
}

t() {
    tmux a -t "$1"
}

# New named tmux session (or attach if it exists). Usage: tn <name>
tn() {
    tmux new-session -A -s "$1"
}

# mkdir + cd in one step. Usage: mkcd <dir>
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# fzf file picker → opens selection in $EDITOR (or nvim).
# Usage: f          (search from CWD)
#        f path     (search from path)
f() {
    local target="${1:-.}"
    local file
    file=$(
        ( command -v fd >/dev/null && fd --type f --hidden --exclude .git . "$target" \
          || find "$target" -type f -not -path '*/\.git/*' ) \
        | "$HOME/.fzf/bin/fzf" --preview 'head -200 {} 2>/dev/null' --preview-window=right:60%
    )
    [[ -n $file ]] && ${EDITOR:-nvim} "$file"
}

# Interactive ripgrep → fzf → open match in $EDITOR at the matching line.
# Usage: rgf [initial-query]
rgf() {
    local rg_cmd="rg --column --line-number --no-heading --color=always --smart-case"
    local selection
    selection=$(
        FZF_DEFAULT_COMMAND="$rg_cmd ${1:-''}" \
        "$HOME/.fzf/bin/fzf" --ansi --disabled \
            --bind "change:reload:$rg_cmd {q} || true" \
            --delimiter : \
            --preview 'sed -n "{2}p" {1} 2>/dev/null; echo; sed -n "$(({2}-3)),$(({2}+10))p" {1} 2>/dev/null' \
            --preview-window=right:60%
    )
    if [[ -n $selection ]]; then
        local file=${selection%%:*}
        local line=$(echo "$selection" | awk -F: '{print $2}')
        ${EDITOR:-nvim} "+${line}" "$file"
    fi
}

# =========================
# History
# =========================
HISTSIZE=50000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# =========================
# Completion — orange highlights, case-insensitive matching
# =========================
autoload -Uz compinit
compinit

# Color directories orange (208) in ls/completion; keep symlinks etc. legible
export LS_COLORS="di=38;5;208:ln=38;5;245:so=38;5;208:pi=38;5;245:ex=38;5;215:bd=38;5;245:cd=38;5;245:su=38;5;160:sg=38;5;160:tw=38;5;208:ow=38;5;208"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{208}%B%d%b%f'
zstyle ':completion:*:warnings'     format '%F{160}no matches: %d%f'
zstyle ':completion:*:messages'     format '%F{208}%d%f'

# Match the autosuggestion ghost-text color to the muted theme
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# =========================
# Git branch helper
# =========================
parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# =========================
# Prompt — orange/black, matched to tmux
#   line 1:  hostname  ~/path  (branch)              ← (right) exit-status pill
#   line 2:  ❯
# =========================
setopt PROMPT_SUBST

# Continuation lines (e.g. inside an unterminated quote) get an orange marker
PROMPT2='%F{208}❯%f '

PROMPT='%F{245}%m %F{208}%~%f%F{240}$(b=$(parse_git_branch); [[ -n $b ]] && print -n "  $b")%f
%(?.%F{208}.%F{160})❯%f '

# Right prompt: show non-zero exit codes subtly, and current time
RPROMPT='%(?..%F{160}✗ %?%f )%F{240}%*%f'

# =========================
# Oh My Zsh + fzf
# =========================
source $ZSH/oh-my-zsh.sh
source <("$HOME/.fzf/bin/fzf" --zsh)

# fzf: orange-on-black palette to match tmux/nvim
export FZF_DEFAULT_OPTS="
  --height=40% --border=rounded --layout=reverse --info=inline
  --prompt='❯ ' --pointer='▶' --marker='✓'
  --color=bg+:#1f1611,bg:#121212,spinner:#ff8700,hl:#ff8700
  --color=fg:#bcbcbc,header:#ff8700,info:#5a5a5a,pointer:#ff8700
  --color=marker:#87af5f,fg+:#ffaf5f,prompt:#ff8700,hl+:#ffaf5f
  --color=border:#2a1f15
"

# =========================
# Autosuggestions
# =========================
bindkey '^@' autosuggest-accept
bindkey '^I' expand-or-complete
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# =========================
# Custom fzf-powered history widget
# =========================
fzf-history-widget() {
  local selected
  selected=$(
    fc -rl 1 \
      | awk '{$1=""; print substr($0,2)}' \
      | awk '!seen[$0]++' \
      | "$HOME/.fzf/bin/fzf" --height=40% --border --ansi --prompt='History> '
  )
  if [[ -n $selected ]]; then
    LBUFFER=$selected
  fi
  zle redisplay
}
zle -N fzf-history-widget

# Up arrow binding
bindkey -r '^[[A'
bindkey '^[[A' fzf-history-widget


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
