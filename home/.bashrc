# .bashrc 

# GLOBAL DEFS
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$PATH:$HOME/.spicetify"
export TZ=America/Argentina/Buenos_Aires

# HISTORIAL (mejorado)
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# COMPLETIONS
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# ALIASES ÚTILES
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias cl='clear'
alias c='clear'

# Pacman y AUR
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -Rns'
alias pacu='sudo pacman -Syu'
alias parus='paru -S'
alias paruu='paru -Syu'

# Navegación rápida
alias ..='cd ..'
alias ...='cd ../..'
alias dots='cd ~/dotfiles'

# Git
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gch='git checkout'

# Neovim
alias v='nvim'

# FUNCIONES ÚTILES
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "No puedo extraer '$1'..." ;;
        esac
    else
        echo "'$1' no existe."
    fi
}

# COLORS
BLUE="\[\e[38;5;33m\]"       # Azul 
CYAN="\[\e[38;5;81m\]"       # Celeste suave
GOLD="\[\e[38;5;220m\]"      # Dorado (para φ)
GREEN="\[\e[38;5;48m\]"      # Verde OK
RED="\[\e[38;5;196m\]"       # Rojo error
WHITE="\[\e[97m\]"
RESET="\[\e[0m\]"


parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

git_status_symbol() {
    git diff --quiet 2>/dev/null && echo "OK" || echo "DIRTY"
}


# STATUS CODE DEL ÚLTIMO COMANDO
exit_icon() {
    [[ $? -eq 0 ]] && echo -e "${GREEN}✓${RESET}" || echo -e "${RED}✗${RESET}"
}


PS1="${BLUE}\u@\h ${CYAN}\w \
\$(branch=\$(parse_git_branch); \
if [[ -n \$branch ]]; then \
    status=\$(git_status_symbol); \
    if [[ \$status == OK ]]; then \
        echo \"${WHITE}[\${branch} ${GREEN}✓${WHITE}]\"; \
    else \
        echo \"${WHITE}[\${branch} ${RED}✗${WHITE}]\"; \
    fi; \
fi) \
${CYAN}\A ${GOLD}φ ${RESET}"


# Extra: load ~/.bashrc.d/*
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f \"$rc\" ] && . \"$rc\"
    done
fi
unset rc
