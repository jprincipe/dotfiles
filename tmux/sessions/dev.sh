#!/bin/bash
DETACH=false
if [ "$1" = "-d" ]; then DETACH=true; shift; fi

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
SESSION="${2:-$(basename "$PROJECT_DIR")}"

# Sanitize session name for tmux (dots and colons are problematic)
SESSION="${SESSION//./-}"
SESSION="${SESSION//:/-}"

# Attach if session already exists
if tmux has-session -t "$SESSION" 2>/dev/null; then
  [ "$DETACH" = true ] && exit 0
  tmux attach-session -t "$SESSION"
  exit 0
fi

# Window 1: editor (nvim 75%, claude 25%)
tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" -n "editor"
tmux send-keys -t "$SESSION:editor" "nvim" Enter
tmux split-window -t "$SESSION:editor" -h -p 25 -c "$PROJECT_DIR"
tmux send-keys "claude" Enter
tmux select-pane -t "$SESSION:editor.1"

# Window 2: terminal
tmux new-window -t "$SESSION" -n "terminal" -c "$PROJECT_DIR"

# Focus on editor
tmux select-window -t "$SESSION:editor"
[ "$DETACH" = true ] || tmux attach-session -t "$SESSION"
