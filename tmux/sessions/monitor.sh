#!/bin/bash
DETACH=false
if [ "$1" = "-d" ]; then DETACH=true; shift; fi

SESSION="monitor"

# Attach if session already exists
if tmux has-session -t "$SESSION" 2>/dev/null; then
  [ "$DETACH" = true ] && exit 0
  tmux attach-session -t "$SESSION"
  exit 0
fi

# Layout: [k9s / btop] | [full-height terminal]
tmux new-session -d -s "$SESSION" -n "monitor"

# Left column: k9s (pane 1)
tmux send-keys -t "$SESSION:monitor" "k9s" Enter

# Right column: full-height terminal (pane 2)
tmux split-window -t "$SESSION:monitor" -h -p 50

# Split left column: btop below k9s (pane 3)
tmux select-pane -t "$SESSION:monitor.1"
tmux split-window -t "$SESSION:monitor.1" -v -p 50
tmux send-keys "btop" Enter

tmux select-pane -t "$SESSION:monitor.2"
[ "$DETACH" = true ] || tmux attach-session -t "$SESSION"
