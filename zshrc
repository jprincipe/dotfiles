######################################
# zsh config
######################################
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

# Enable completion system
autoload -Uz compinit
compinit

if [[ "$OSTYPE" == darwin* ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

######################################
# Default shell values
######################################
export LANG=en_US.UTF-8
export EDITOR='nvim'
export K9S_CONFIG_DIR="$HOME/.config/k9s"

######################################
# aliases
######################################

# nvim
alias vi="nvim"
alias vim="nvim"

# tmux
alias ta="tmux attach"
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t"
alias tn="tmux new -s"

# eza
alias ls="eza --color=always --icons=always"

# zoxide
eval "$(zoxide init zsh)"

# Starship
eval "$(starship init zsh)"
eval "$(mise activate zsh)"

# direnv
eval "$(direnv hook zsh)"

######################################
# PATH
######################################

# Update PATH to include homebrew
if [[ "$OSTYPE" == darwin* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/jprincipe/.docker/completions $fpath)
# End of Docker CLI completions

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
export PATH="$HOME/.local/bin:$PATH"

# Claude Code session archive browser
[ -f "$HOME/.config/zsh/claude-archive.zsh" ] && source "$HOME/.config/zsh/claude-archive.zsh"

######################################
# herdr pane names
######################################
if [[ -n $HERDR_PANE_ID ]] && command -v herdr >/dev/null 2>&1; then
  autoload -Uz add-zsh-hook

  _herdr_pane_set() {
    [[ $_HERDR_PANE_NAME == "$1" ]] && return
    _HERDR_PANE_NAME=$1
    herdr pane rename "$HERDR_PANE_ID" "$1" >/dev/null 2>&1
  }

  # herdr detects these itself; a manual label would shadow its own
  _herdr_pane_clear() {
    [[ -z $_HERDR_PANE_NAME ]] && return
    _HERDR_PANE_NAME=
    herdr pane rename "$HERDR_PANE_ID" --clear >/dev/null 2>&1
  }

  _herdr_pane_preexec() {
    case ${1%% *} in
      claude|codex|nvim|vim|vi) _herdr_pane_clear ;;
      k9s|btop|htop|top|lazygit|yazi|psql) _herdr_pane_set "${1%% *}" ;;
      *) _herdr_pane_set "${PWD:t}" ;;
    esac
  }

  _herdr_pane_precmd() { _herdr_pane_set "${PWD:t}" }

  add-zsh-hook preexec _herdr_pane_preexec
  add-zsh-hook precmd _herdr_pane_precmd
fi
