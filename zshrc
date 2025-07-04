######################################
# zsh & oh-my-zsh config
######################################

# Path to your Oh My Zsh installation.
export ZSH=$HOME/.oh-my-zsh

# update automatically without asking
zstyle ':omz:update' mode auto

DISABLE_UNTRACKED_FILES_DIRTY="true"
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
HIST_STAMPS="yyyy-mm-dd"
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "\e[1;3D" backward-word     # ⌥←
bindkey "\e[1;3C" forward-word      # ⌥→
bindkey "^[[1;9D" beginning-of-line # cmd+←
bindkey "^[[1;9C" end-of-line       # cmd+→

plugins=(git dotenv)

source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

######################################
# Default shell values
######################################
export LANG=en_US.UTF-8
export EDITOR='nvim'

######################################
# aliases
######################################

# nvim
alias vi="nvim"
alias vim="nvim"

# eza 
alias ls="eza --color=always --icons=always"

# zoxide
eval "$(zoxide init zsh)"

# Starship
eval "$(starship init zsh)"
eval "$(mise activate zsh)"

######################################
# PATH 
######################################

# Update PATH to include homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

. "$HOME/.local/bin/env"
