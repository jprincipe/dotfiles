#!/bin/bash
DETACH=false
if [ "$1" = "-d" ]; then DETACH=true; shift; fi

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
SESSION="${2:-$(basename "$PROJECT_DIR")}"

# Sanitize session name for tmux (dots and colons are problematic)
SESSION="${SESSION//./-}"
SESSION="${SESSION//:/-}"

# Use switch-client when inside tmux, attach-session otherwise
attach_or_switch() {
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "=$SESSION"
  else
    tmux attach-session -t "=$SESSION"
  fi
}

# Attach if session already exists (exact match via =)
if tmux has-session -t "=$SESSION" 2>/dev/null; then
  [ "$DETACH" = true ] && exit 0
  attach_or_switch
  exit 0
fi

# Window 1: editor (nvim 80%, claude 20%)
tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" -n "editor" -x "$(tput cols)" -y "$(tput lines)"
tmux send-keys -t "$SESSION:editor" "nvim" Enter
tmux split-window -t "$SESSION:editor" -h -l 20% -c "$PROJECT_DIR"
tmux send-keys "claude" Enter
tmux select-pane -t "$SESSION:editor.1"

# Window 2: terminal (with pane border labels)
tmux new-window -t "$SESSION" -n "terminal" -c "$PROJECT_DIR"
tmux set-option -w -t "$SESSION:terminal" pane-border-status top

# Focus on editor
tmux select-window -t "$SESSION:editor"
[ "$DETACH" = true ] || attach_or_switch
