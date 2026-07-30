#!/usr/bin/env bash
# Sesh picker: tmux sessions + ~/dev/* dirs.
# Tmux sessions are annotated with Claude Code state (✻):
#   red     blocked  (waiting on a permission prompt or your input)
#   orange  working  (processing a prompt)
#   green   done     (finished responding)
#   grey    unknown  (claude is running but hasn't reported yet)
#   blank            (no claude in any pane)
# ctrl-x kills the highlighted tmux session and reloads the list.

# State comes from the @agent pane option, which Claude Code hooks in
# ~/.claude/settings.json set on $TMUX_PANE (see the "agent state" block in
# tmux.conf — the window tabs read the same option). This replaced scraping the
# pane title for a braille spinner, which could only tell busy from not-busy:
# "waiting for permission" and "finished 20 minutes ago" looked identical.
#
# `-s` lists panes across ALL windows of the session; a bare `-t <session>`
# resolves to the session's current window only and would miss a claude parked
# in another window.
#
# pane_current_command is still checked so a dead agent's last state is ignored.
# It is plain "claude" on current versions; older ones renamed the process to
# their version string (e.g. "2.1.111"), so both are matched.
claude_state() {
  local sess="$1" blocked=0 working=0 finished=0 unknown=0 cmd state
  while IFS=$'\t' read -r cmd state; do
    [[ "$cmd" =~ ^([0-9.]+|claude)$ ]] || continue
    case "$state" in
      blocked) blocked=1 ;;
      working) working=1 ;;
      done)    finished=1 ;;
      *)       unknown=1 ;;
    esac
  done < <(tmux list-panes -s -t "$sess" -F $'#{pane_current_command}\t#{@agent}' 2>/dev/null)
  # Claude sparkle glyph (✻). Colors match the tmux status-bar dots.
  if   (( blocked ));  then printf '\033[38;2;191;97;106m✻\033[0m'   # #BF616A
  elif (( working ));  then printf '\033[38;2;217;119;87m✻\033[0m'   # #D97757
  elif (( finished )); then printf '\033[38;2;163;190;140m✻\033[0m'  # #A3BE8C
  elif (( unknown ));  then printf '\033[38;2;76;86;106m✻\033[0m'    # #4C566A
  else                      printf ' '
  fi
}

list() {
  local sess state dir name
  while IFS= read -r sess; do
    [ -z "$sess" ] && continue
    state=$(claude_state "$sess")
    printf '%s\t%s\n' "$state" "$sess"
  done < <(tmux list-sessions -F '#S' 2>/dev/null)

  while IFS= read -r dir; do
    name=$(basename "$dir")
    tmux has-session -t "$name" 2>/dev/null && continue
    printf ' \t%s\n' "$dir"
  done < <(find ~/dev -mindepth 1 -maxdepth 1 -type d -not -name '.*' 2>/dev/null)
}

if [ "$1" = "--list" ]; then
  list
  exit 0
fi

pick=$(
  list | fzf \
    --reverse --ansi --no-sort \
    --delimiter=$'\t' \
    --with-nth=1,2 \
    --tabstop=2 \
    --prompt '⚡  ' \
    --header 'enter: connect   ctrl-x: kill session' \
    --bind "ctrl-x:execute-silent(tmux kill-session -t {2} 2>/dev/null)+reload($0 --list)"
)

[ -z "$pick" ] && exit 0
target=$(printf '%s' "$pick" | awk -F'\t' '{print $2}')
exec sesh connect "$target"
