#!/bin/bash
DETACH=false
if [ "$1" = "-d" ]; then DETACH=true; shift; fi

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
SESSION="$(basename "$PROJECT_DIR")"

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

# Window 2: ef-apps (2x2 grid)
tmux new-window -t "$SESSION" -n "ef-apps"
tmux send-keys -t "$SESSION:ef-apps" "cd $PROJECT_DIR/apps/ef_portal" Enter

tmux split-window -t "$SESSION:ef-apps"
tmux send-keys "cd $PROJECT_DIR/apps/ef_call_api" Enter
tmux select-layout -t "$SESSION:ef-apps" tiled

tmux split-window -t "$SESSION:ef-apps"
tmux send-keys "cd $PROJECT_DIR/apps/ef_publisher_api" Enter
tmux select-layout -t "$SESSION:ef-apps" tiled

tmux split-window -t "$SESSION:ef-apps"
tmux send-keys "cd $PROJECT_DIR/apps/ef_workers" Enter
tmux select-layout -t "$SESSION:ef-apps" tiled

# Window 3: wr-apps (2x2 grid)
tmux new-window -t "$SESSION" -n "wr-apps"
tmux send-keys -t "$SESSION:wr-apps" "cd $PROJECT_DIR/apps/wr_portal" Enter

tmux split-window -t "$SESSION:wr-apps"
tmux send-keys "cd $PROJECT_DIR/apps/wr_service_api" Enter
tmux select-layout -t "$SESSION:wr-apps" tiled

tmux split-window -t "$SESSION:wr-apps"
tmux send-keys "cd $PROJECT_DIR/apps/wr_event_api" Enter
tmux select-layout -t "$SESSION:wr-apps" tiled

tmux split-window -t "$SESSION:wr-apps"
tmux send-keys "cd $PROJECT_DIR/apps/wr_workers" Enter
tmux select-layout -t "$SESSION:wr-apps" tiled

# Focus on editor
tmux select-window -t "$SESSION:editor"
[ "$DETACH" = true ] || tmux attach-session -t "$SESSION"
