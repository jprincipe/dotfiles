#!/usr/bin/env bash
# Sesh picker: tmux sessions + sesh configs + ~/Development/* dirs.
# ctrl-x kills the highlighted tmux session and reloads the list.

list() {
  sesh list -tci
  find ~/Development -mindepth 1 -maxdepth 1 -type d -not -name '.*'
}

if [ "$1" = "--list" ]; then
  list
  exit 0
fi

pick=$(
  list | fzf \
    --reverse --ansi --no-sort \
    --prompt '⚡  ' \
    --header 'enter: connect   ctrl-x: kill session' \
    --bind "ctrl-x:execute-silent(tmux kill-session -t {2..} 2>/dev/null)+reload($0 --list)"
)

[ -n "$pick" ] && exec sesh connect "$pick"
