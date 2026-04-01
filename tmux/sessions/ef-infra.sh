#!/bin/bash
DETACH=false
if [ "$1" = "-d" ]; then DETACH=true; shift; fi

SESSION="ef-infra"
PROJECT_DIR="$HOME/Development/ef"

# Attach if session already exists
if tmux has-session -t "$SESSION" 2>/dev/null; then
  [ "$DETACH" = true ] && exit 0
  tmux attach-session -t "$SESSION"
  exit 0
fi

# Window 1: docker
tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" -n "docker"

# Window 2: tunnel
tmux new-window -t "$SESSION" -n "tunnel" -c "$PROJECT_DIR"

# Focus on docker
tmux select-window -t "$SESSION:docker"
[ "$DETACH" = true ] || tmux attach-session -t "$SESSION"
