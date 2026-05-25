# =========================
# Global config if present
# =========================
[ -f /etc/bashrc ] && . /etc/bashrc

# Non-interactive shells: do nothing else.
case $- in
    *i*) ;;
    *) return 2>/dev/null ;;
esac

# =========================
# Prefer zsh when it's available AND the terminal can render it well.
# Skips on dumb terminals, when zsh isn't installed, or when NO_AUTO_ZSH=1.
# =========================
__term_is_capable() {
    [ -n "$TERM" ] && [ "$TERM" != "dumb" ] || return 1
    command -v tput >/dev/null 2>&1 || return 1
    local n
    n=$(tput colors 2>/dev/null) || return 1
    [ "${n:-0}" -ge 8 ]
}

if [ -z "$NO_AUTO_ZSH" ] \
   && [ -z "$BASH_FALLBACK" ] \
   && [ -z "$INSIDE_EMACS" ] \
   && command -v zsh >/dev/null 2>&1 \
   && __term_is_capable; then
    export SHELL="$(command -v zsh)"
    exec zsh -l
fi

# -------------------------------------------------------------------------
# Fallback: bash configuration mirroring ~/.zshrc, sans zsh-only features.
# -------------------------------------------------------------------------

if __term_is_capable; then
    __color=1
else
    __color=0
fi

# =========================
# User PATH
# =========================
case ":$PATH:" in
  *":$HOME/.local/bin:$HOME/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$HOME/bin:$PATH" ;;
esac

# =========================
# Conda
# =========================
__conda_setup="$('/bwrcq/home/nicorakela/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

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

alias gt='git log --graph --decorate --oneline --all'
alias gs='git status'
alias gl='git log'
alias vcs='cd $CY_DIR/sims/vcs'
alias vim='nvim'
alias vi='nvim'

# ---- Nav + ls helpers ----
alias ll='ls -lh'
alias la='ls -lAh'
alias lt='ls -lAhtr'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ---- Git shortcuts ----
alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gd='git diff'
alias gb='git branch'

# ---- tmux shortcuts ----
alias ta='tmux attach'
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

tn() {
    tmux new-session -A -s "$1"
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

f() {
    local target="${1:-.}"
    local file
    file=$(
        ( command -v fd >/dev/null && fd --type f --hidden --exclude .git . "$target" \
          || find "$target" -type f -not -path '*/\.git/*' ) \
        | "$HOME/.fzf/bin/fzf" --preview 'head -200 {} 2>/dev/null' --preview-window=right:60%
    )
    [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

rgf() {
    local rg_cmd="rg --column --line-number --no-heading --color=always --smart-case"
    local preview='awk -v n={2} '"'"'BEGIN{a=n-3;b=n+10} NR>=a && NR<=b {printf "%s%4d │ %s\n", (NR==n?"▶ ":"  "), NR, $0}'"'"' {1} 2>/dev/null'
    local selection
    selection=$(
        FZF_DEFAULT_COMMAND="$rg_cmd ${1:-.}" \
        "$HOME/.fzf/bin/fzf" --ansi --disabled \
            --bind "change:reload:$rg_cmd {q} || true" \
            --delimiter : \
            --preview "$preview" \
            --preview-window=right:60%
    )
    if [ -n "$selection" ]; then
        local file=${selection%%:*}
        local line
        line=$(echo "$selection" | awk -F: '{print $2}')
        ${EDITOR:-nvim} "+${line}" "$file"
    fi
}

# =========================
# History
# =========================
HISTSIZE=50000
HISTFILESIZE=100000
HISTFILE=~/.bash_history
HISTCONTROL=ignoredups:erasedups
shopt -s histappend 2>/dev/null
shopt -s cmdhist 2>/dev/null
# Share history across sessions (close to zsh's SHARE_HISTORY).
case "$PROMPT_COMMAND" in
    *"history -a"*) ;;
    *) PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:-}" ;;
esac

# =========================
# Completion (bash)
# =========================
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
bind 'set completion-ignore-case on' 2>/dev/null
bind 'set show-all-if-ambiguous on' 2>/dev/null
bind 'set colored-stats on'         2>/dev/null

# =========================
# Colors + prompt
# =========================
parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

if [ "$__color" = "1" ]; then
    export LS_COLORS="di=38;5;208:ln=38;5;245:so=38;5;208:pi=38;5;245:ex=38;5;215:bd=38;5;245:cd=38;5;245:su=38;5;160:sg=38;5;160:tw=38;5;208:ow=38;5;208"

    # line 1:  hostname  ~/path  (branch)
    # line 2:  ❯   (red on non-zero exit)
    __prompt_marker() { [ "$1" = "0" ] && printf '\001\e[38;5;208m\002' || printf '\001\e[38;5;160m\002'; }
    PS1='\[\e[38;5;245m\]\h \[\e[38;5;208m\]\w\[\e[38;5;240m\]$(b=$(parse_git_branch); [ -n "$b" ] && printf "  %s" "$b")\[\e[0m\]\n$(__prompt_marker $?)❯\[\e[0m\] '
    PS2='\[\e[38;5;208m\]❯\[\e[0m\] '
else
    PS1='\h \w$(b=$(parse_git_branch); [ -n "$b" ] && printf "  %s" "$b")\n❯ '
    PS2='❯ '
fi

# =========================
# fzf
# =========================
if [ "$__color" = "1" ]; then
    export FZF_DEFAULT_OPTS="
      --height=40% --border=rounded --layout=reverse --info=inline
      --prompt='❯ ' --pointer='▶' --marker='✓'
      --color=bg+:#1f1611,bg:#121212,spinner:#ff8700,hl:#ff8700
      --color=fg:#bcbcbc,header:#ff8700,info:#5a5a5a,pointer:#ff8700
      --color=marker:#87af5f,fg+:#ffaf5f,prompt:#ff8700,hl+:#ffaf5f
      --color=border:#2a1f15
    "
fi

[ -f ~/.fzf.bash ] && . ~/.fzf.bash

unset __color
