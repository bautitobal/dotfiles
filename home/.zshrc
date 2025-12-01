# .zshrc
# HISTORIAL
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt hist_ignore_dups hist_reduce_blanks share_history

# COMPLETIONS
autoload -Uz compinit
compinit

# AUTOSUGGESTIONS
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'  # gris sutil

# SYNTAX HIGHLIGHTING
# Usar fast si está disponible
if [ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]; then
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
else
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# OPCIONES ZSH
setopt autocd           # cd solo escribiendo ruta
setopt correct          # autocorrección de comandos
setopt interactive_comments
setopt extended_glob
bindkey -e

##############################################
#                  COLORS
##############################################
BLUE="%F{33}"
CYAN="%F{81}"
GOLD="%F{220}"
GREEN="%F{48}"
RED="%F{196}"
WHITE="%F{255}"
RESET="%f"


##############################################
#              GIT FUNCTIONS
##############################################
git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

git_status_symbol() {
    git diff --quiet 2>/dev/null && echo "${GREEN}✓${RESET}" || echo "${RED}✗${RESET}"
}

##############################################
#                PROMPT (PS1)
##############################################
setopt prompt_subst
PROMPT="${BLUE}%n@%m ${CYAN}%~ \
\$(branch=\$(git_branch); if [[ -n \$branch ]]; then gstatus=\$(git_status_symbol); echo \"${WHITE}[\$branch \$gstatus${WHITE}]\"; fi) \
${CYAN}%T ${GOLD}φ ${RESET}"

##############################################
#                  ALIASES
##############################################
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias cl='clear'
alias c='clear'

# Pacman y AUR
alias pacs='sudo pacman -S'
alias pacr='sudo pacman -Rns'
alias pacu='sudo pacman -Syu'
alias paru='paru -S'
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
