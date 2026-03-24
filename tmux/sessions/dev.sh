#!/bin/bash
SESSION="dev"
PROJECT_DIR="${1:-$HOME/Development/exchange-flo-app}"

# Attach if session already exists
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach-session -t "$SESSION"
  exit 0
fi

# Window 1: editor
tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" -n "editor"
tmux send-keys -t "$SESSION:editor" "nvim" Enter

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

# Window 4: docker
tmux new-window -t "$SESSION" -n "docker" -c "$PROJECT_DIR"

# Window 5: tunnel
tmux new-window -t "$SESSION" -n "tunnel" -c "$PROJECT_DIR"

# Focus on editor
tmux select-window -t "$SESSION:editor"
tmux attach-session -t "$SESSION"
