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

# tmux
alias ta="tmux attach"
alias tl="tmux list-sessions"
alias tk="tmux kill-session -t"

ts() {
  local SESSIONS_DIR="$HOME/.config/tmux/sessions"

  # ts -b <branch> -- open/create worktree session for branch
  if [ "$1" = "-b" ]; then
    shift
    local branch="$1"
    if [ -z "$branch" ]; then echo "Usage: ts -b <branch>"; return 1; fi

    local repo_dir
    repo_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -z "$repo_dir" ]; then echo "Not in a git repo."; return 1; fi

    # Follow to the main worktree if inside a linked worktree
    local main_wt
    main_wt="$(git -C "$repo_dir" worktree list --porcelain | head -1 | sed 's/^worktree //')"
    repo_dir="$main_wt"

    # main/master: use repo dir directly, no worktree
    if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
      bash "$SESSIONS_DIR/dev.sh" "$repo_dir"
      return 0
    fi

    # Check if branch exists locally
    if git -C "$repo_dir" show-ref --verify --quiet "refs/heads/$branch"; then
      # Branch exists -- switch to its worktree (creates worktree if needed)
      (cd "$repo_dir" && wt switch "$branch")
    else
      # Branch doesn't exist -- prompt to create
      printf "Branch '%s' does not exist. Create it? [y/N] " "$branch"
      read -r answer
      if [[ "$answer" =~ ^[Yy]$ ]]; then
        (cd "$repo_dir" && wt switch -c "$branch")
      else
        return 0
      fi
    fi

    # Resolve the worktree directory for this branch
    local wt_dir
    wt_dir="$(git -C "$repo_dir" worktree list --porcelain | \
      awk -v b="refs/heads/$branch" '/^worktree /{p=$2} /^branch /{if ($2 == b) print p}')"

    if [ -z "$wt_dir" ]; then
      echo "Could not resolve worktree directory for branch: $branch"; return 1
    fi

    bash "$SESSIONS_DIR/dev.sh" "$wt_dir"
    return 0
  fi

  # ts -d <branch> -- remove worktree and kill tmux session
  if [ "$1" = "-d" ]; then
    shift
    local branch="$1"
    if [ -z "$branch" ]; then echo "Usage: ts -d <branch>"; return 1; fi

    local repo_dir
    repo_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -z "$repo_dir" ]; then echo "Not in a git repo."; return 1; fi

    local main_wt
    main_wt="$(git -C "$repo_dir" worktree list --porcelain | head -1 | sed 's/^worktree //')"
    repo_dir="$main_wt"

    # Find the worktree path for this branch
    local wt_dir
    wt_dir="$(git -C "$repo_dir" worktree list --porcelain | \
      awk -v b="refs/heads/$branch" '/^worktree /{p=$2} /^branch /{if ($2 == b) print p}')"

    if [ -z "$wt_dir" ]; then
      echo "No worktree found for branch: $branch"; return 1
    fi

    # Kill the tmux session named after the worktree directory
    local sess_name
    sess_name="$(basename "$wt_dir")"
    sess_name="${sess_name//./-}"
    sess_name="${sess_name//:/-}"
    tmux kill-session -t "$sess_name" 2>/dev/null

    # Remove the worktree via worktrunk
    (cd "$repo_dir" && wt remove "$branch")
    return 0
  fi

  # ts <name> -- run a session script if it matches
  if [ -n "$1" ] && [ -f "$SESSIONS_DIR/$1.sh" ]; then
    bash "$SESSIONS_DIR/$1.sh" "${@:2}"
    return 0
  fi

  # ts (no args) -- fzf picker showing session scripts + local branches
  local choices=()

  # Add session scripts (excluding dev.sh which is used internally)
  local scripts=("$SESSIONS_DIR"/*.sh(N))
  for s in "${scripts[@]}"; do
    local name="${s:t:r}"
    [ "$name" = "dev" ] && continue
    choices+=("session: $name")
  done

  # Add local branches if in a git repo
  local repo_dir
  repo_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
  if [ -n "$repo_dir" ]; then
    local main_wt
    main_wt="$(git -C "$repo_dir" worktree list --porcelain | head -1 | sed 's/^worktree //')"
    local branches
    branches="$(git -C "$main_wt" branch --format='%(refname:short)' 2>/dev/null)"
    while IFS= read -r b; do
      [ -n "$b" ] && choices+=("branch: $b")
    done <<< "$branches"
  fi

  if [ ${#choices[@]} -eq 0 ]; then
    echo "No session scripts or branches found"; return 1
  fi

  local choice
  choice="$(printf '%s\n' "${choices[@]}" | fzf --prompt="ts> ")"
  [ -z "$choice" ] && return 0

  if [[ "$choice" == session:* ]]; then
    local name="${choice#session: }"
    bash "$SESSIONS_DIR/$name.sh"
  elif [[ "$choice" == branch:* ]]; then
    local branch="${choice#branch: }"
    ts -b "$branch"
  fi
}

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
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

. "$HOME/.local/bin/env"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/jprincipe/.docker/completions $fpath)
# End of Docker CLI completions

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
