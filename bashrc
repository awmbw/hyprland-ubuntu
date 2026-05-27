# ╔══════════════════════════════════════════════════════════════╗
# ║              Bash Configuration — Omarchy-style              ║
# ║              Enhanced shell with modern dev tools             ║
# ╚══════════════════════════════════════════════════════════════╝

# ── If not running interactively, don't do anything ───────────
[[ $- != *i* ]] && return

# ── Source system defaults ────────────────────────────────────
[ -f /etc/bashrc ] && source /etc/bashrc

# ── History ───────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# ── Shell Options ─────────────────────────────────────────────
shopt -s checkwinsize
shopt -s globstar 2>/dev/null
shopt -s autocd 2>/dev/null
shopt -s cdspell 2>/dev/null

# ── Modern CLI Replacements ───────────────────────────────────
# eza → ls replacement
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2'
    alias la='eza -a --icons --group-directories-first'
fi

# bat → cat replacement
if command -v batcat &>/dev/null; then
    alias cat='batcat --paging=never --style=plain'
    alias bat='batcat'
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
elif command -v bat &>/dev/null; then
    alias cat='bat --paging=never --style=plain'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# fd → find replacement (Ubuntu names it fdfind)
if command -v fdfind &>/dev/null; then
    alias fd='fdfind'
fi

# ripgrep
if command -v rg &>/dev/null; then
    alias grep='rg'
fi

# ── Convenience Aliases ───────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias df='df -h'
alias du='du -sh'
alias q='exit'
alias c='clear'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias lg='lazygit'
alias top='btop'

# ── Fuzzy File Finder (Omarchy-style ff) ─────────────────────
ff() {
    local preview_cmd="batcat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}"
    if command -v fdfind &>/dev/null; then
        fdfind --type f --hidden --follow --exclude .git | fzf --preview "$preview_cmd" --bind 'enter:become(nvim {})'
    elif command -v fd &>/dev/null; then
        fd --type f --hidden --follow --exclude .git | fzf --preview "$preview_cmd" --bind 'enter:become(nvim {})'
    else
        fzf --preview "$preview_cmd" --bind 'enter:become(nvim {})'
    fi
}

# ── Shell Functions (Omarchy-style) ──────────────────────────
compress() { tar -czvf "${1}.tar.gz" "$1"; }
decompress() { tar -xzvf "$1"; }


# ── Git Aliases ───────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# ── Hyprland Helpers ──────────────────────────────────────────
alias hyprconf='nvim ~/.config/hypr/hyprland.conf'
alias hyprlog='cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -1)/hyprland.log'
alias hyprreload='hyprctl reload'

# ── FZF Integration ──────────────────────────────────────────
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash 2>/dev/null)" || true
    export FZF_DEFAULT_OPTS="
        --color=bg+:#123748,bg:#0d2b3e,spinner:#3ba5c9,hl:#52bde0
        --color=fg:#d4dce8,header:#52bde0,info:#9a7acf,pointer:#3ba5c9
        --color=marker:#8ab434,fg+:#d4dce8,prompt:#9a7acf,hl+:#52bde0
        --border=rounded --padding=1 --margin=0
        --prompt='▶ ' --pointer='→' --marker='✓'
    "
    # Use fd for fzf if available
    if command -v fdfind &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
    fi
fi

# ── Starship Prompt ───────────────────────────────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# ── Fastfetch on new terminal ─────────────────────────────────
if command -v fastfetch &>/dev/null && [[ -z "$TMUX" ]]; then
    fastfetch --logo small
fi

# ── PATH additions ────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# ── Editor ────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'

# ── Wayland ───────────────────────────────────────────────────
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=auto

# ── Zoxide (smart cd) — MUST be last ─────────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
    alias cd='z'
fi
