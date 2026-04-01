# Tmux Cheatsheet

Prefix: `Ctrl+Space`

## Navigation

| Shortcut | Action |
|----------|--------|
| `Ctrl+h/j/k/l` | Move between panes (vim-aware, works inside nvim) |
| `Ctrl+Shift+H` | Previous window |
| `Ctrl+Shift+L` | Next window |
| `Alt+H` | Previous window (fallback) |
| `Alt+L` | Next window (fallback) |
| `Alt+1-9` | Jump to window by number |
| `Ctrl+,` | Previous session |
| `Ctrl+.` | Next session |
| `prefix s` | Fuzzy search sessions (fzf popup) |

## Windows & Panes

| Shortcut | Action |
|----------|--------|
| `prefix c` | New window (inherits current path) |
| `prefix \|` | Split pane horizontally (inherits path) |
| `prefix -` | Split pane vertically (inherits path) |

## Copy Mode (vi)

| Shortcut | Action |
|----------|--------|
| `prefix [` | Enter copy mode |
| `v` | Begin selection |
| `y` | Copy selection and exit |

## Shell Aliases

```bash
ta                # Attach to last tmux session
tl                # List all tmux sessions
tk <session>      # Kill a tmux session
                  # Example: tk ef-infra
```

## Session Manager (`ts`)

### Interactive Picker

```bash
ts                # fzf picker showing session scripts + local branches
                  #   -> select "session: monitor" to launch monitoring
                  #   -> select "branch: jp/feature" to open worktree session
```

### Named Sessions

```bash
ts <name>         # Launch a session script by name
                  # Example: ts monitor     (k9s + btop monitoring)
                  # Example: ts ef-infra    (docker + tunnel windows)
```

### Branch / Worktree Sessions (`-b`)

```bash
ts -b <branch>    # Open session for a branch (creates worktree if needed)

                  # Main branch -- uses repo dir directly, no worktree
                  # Example: ts -b main

                  # Existing branch -- creates worktree and tmux session
                  # Example: ts -b jp/traffic-groups
                  #   -> worktree at ~/Development/ef.jp-traffic-groups/
                  #   -> tmux session with nvim + claude + terminal

                  # Re-attach to existing worktree session
                  # Example: ts -b jp/traffic-groups
                  #   -> if session already exists, attaches to it

                  # New branch -- prompts to create if it doesn't exist
                  # Example: ts -b jp/new-feature
                  #   -> "Branch 'jp/new-feature' does not exist. Create it? [y/N]"
                  #   -> creates branch + worktree + tmux session
```

### Remove Worktree Session (`-d`)

```bash
ts -d <branch>    # Kill tmux session and remove worktree
                  # Example: ts -d jp/traffic-groups
                  #   -> kills tmux session "ef-jp-traffic-groups"
                  #   -> removes worktree via worktrunk
```

## Session Layout

Every `dev` session (main or worktree) opens with:

- **Window 1 "editor"**: nvim (75%) | claude (25%)
- **Window 2 "terminal"**: general purpose shell

## Prerequisites

```bash
brew install worktrunk
wt config shell install
```
