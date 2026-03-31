# Tmux Session Helpers

## Aliases

```bash
# Attach to last tmux session
ta
# Example: ta

# List all tmux sessions
tl
# Example: tl

# Kill a tmux session by name
tk <session-name>
# Example: tk exchange-flo-app
```

## Session Manager (`ts`)

### Interactive Picker

```bash
# Show fzf picker with session scripts and local branches
ts
# Example: ts
#   -> select "session: monitor" to launch monitoring
#   -> select "branch: jp/traffic-groups" to open worktree session
```

### Named Sessions

```bash
# Launch a session script by name
ts <name>
# Example: ts monitor        # launches k9s + btop monitoring
# Example: ts ef-infra       # launches docker + tunnel windows
```

### Branch / Worktree Sessions (`-b`)

```bash
# Open a session for a branch (creates worktree if needed)
ts -b <branch>

# Main branch -- uses repo dir directly, no worktree
# Example: ts -b main

# Existing branch -- creates worktree and tmux session
# Example: ts -b jp/traffic-groups
#   -> worktree at ~/Development/exchange-flo-app.jp-traffic-groups/
#   -> tmux session with nvim + claude + terminal

# Re-attach to existing worktree session
# Example: ts -b jp/traffic-groups
#   -> if session already exists, attaches to it

# New branch -- prompts to create if branch doesn't exist
# Example: ts -b jp/new-feature
#   -> "Branch 'jp/new-feature' does not exist. Create it? [y/N]"
#   -> creates branch + worktree + tmux session
```

### Remove Worktree Session (`-d`)

```bash
# Kill tmux session and remove worktree for a branch
ts -d <branch>
# Example: ts -d jp/traffic-groups
#   -> kills tmux session "exchange-flo-app-jp-traffic-groups"
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
