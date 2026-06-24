#!/usr/bin/env bash
# Layout for ef-family sessions (run by sesh on first connect).
# Window 1 (edit): nvim left ~75% + claude right ~25%
# Window 2 (work): 2 rows × 4 even columns = 8 panes

set -eu

edit_pane="${TMUX_PANE}"

tmux rename-window -t "$edit_pane" edit

# Window 1: claude pane on the right (25%)
tmux split-window -h -l 25% -t "$edit_pane" -c "#{pane_current_path}"
claude_pane=$(tmux display-message -p '#{pane_id}')
tmux send-keys -t "$claude_pane" 'claude' Enter

# Queue nvim in the edit pane; it runs after this script returns control to the shell.
tmux send-keys -t "$edit_pane" 'clear && nvim' Enter

# Window 2: 2 rows (top/bottom), each split into 4 even columns.
tmux new-window -n work -c "#{pane_current_path}"
work_top=$(tmux display-message -p '#{pane_id}')
tmux split-window -v -t "$work_top" -c "#{pane_current_path}"
work_bottom=$(tmux display-message -p '#{pane_id}')

# Split a row into 4 equal-width columns.
# -l <pct> sets the *new* pane's share; the percentages pick out an even quarter each time.
split_quarters() {
  local target="$1"
  tmux split-window -h -l 75% -t "$target" -c "#{pane_current_path}"
  tmux split-window -h -l 67% -c "#{pane_current_path}"
  tmux split-window -h -l 50% -c "#{pane_current_path}"
}

split_quarters "$work_top"
split_quarters "$work_bottom"

# Clear stale prompt artifacts left behind when panes were resized mid-split.
while IFS= read -r p; do
  tmux send-keys -t "$p" 'clear' Enter
done < <(tmux list-panes -t work -F '#{pane_id}')

# Land on the edit window, focused on the nvim pane.
tmux select-window -t edit
tmux select-pane -t "$edit_pane"
