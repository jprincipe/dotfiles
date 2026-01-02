# Neovim Configuration Reference

## Mini Modules

### mini.icons
File icons used throughout the UI (statusline, file explorers, etc.)

### mini.statusline
Custom status line showing:
- **Left**: Mode (NORMAL/INSERT/VISUAL/etc.) | Git branch
- **Center**: Filename
- **Right**: LSP diagnostics | Line:Column

### mini.starter
Start screen with:
- Custom ASCII art header
- Built-in actions (edit, quit, etc.)
- Recent files (local and global)

### mini.comment
Toggle comments with `gc`.

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle comment on line |
| `gc` | Normal | Toggle comment (with motion, e.g., `gc3j`) |
| `gc` | Visual | Toggle comment on selection |

### mini.surround
Surround text with brackets, quotes, tags, etc.

| Key | Action |
|-----|--------|
| `gsa` | Add surrounding (e.g., `gsaiw"` adds `"` around word) |
| `gsd` | Delete surrounding (e.g., `gsd"` deletes surrounding `"`) |
| `gsr` | Replace surrounding (e.g., `gsr"'` replaces `"` with `'`) |
| `gsf` | Find surrounding (move to right) |
| `gsF` | Find surrounding (move to left) |
| `gsh` | Highlight surrounding |
| `gsn` | Update `n_lines` search range |

### mini.indentscope
Visual indent guides showing the current scope.
- Disabled in: help, lazy, mason, notify, oil, starter

### mini.pick
Fuzzy finder/picker.

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Resume picker |
| `<leader><leader>` | Find files |

**Inside picker:**
- `<C-j>` / `<C-k>` - Navigate up/down

### mini.clue
Shows keybinding hints after pressing leader keys.
- Triggers on: `<leader>`, `g`, `z`, `'`, `` ` ``, `"`, `<C-w>`, `[`, `]`, `<C-x>` (insert), `<C-r>` (insert/cmd)

### mini.ai
Enhanced textobjects for `a` (around) and `i` (inside) operations.

| Key | Textobject |
|-----|------------|
| `b` | Brackets: `()`, `[]`, `{}` |
| `q` | Quotes: `"`, `'`, `` ` `` |
| `t` | Tags: `<tag>...</tag>` |
| `f` | Function call |
| `a` | Argument |
| `?` | User prompt (interactive) |

**Examples:**
```
vai     - Select around argument
dif     - Delete inside function call
ciq     - Change inside quotes
yab     - Yank around brackets
vanb    - Select around next brackets
```

### mini.move
Move lines or visual selections.

| Mode | Key | Action |
|------|-----|--------|
| Normal | `Alt+h` | Move line left (dedent) |
| Normal | `Alt+j` | Move line down |
| Normal | `Alt+k` | Move line up |
| Normal | `Alt+l` | Move line right (indent) |
| Visual | `Alt+hjkl` | Move selection |

### mini.splitjoin
Toggle between single-line and multi-line.

| Key | Action |
|-----|--------|
| `gS` | Toggle split/join |

```lua
-- Before:
func(a, b, c)

-- After gS:
func(
  a,
  b,
  c
)
```

### mini.bufremove
Delete buffers without closing windows.

| Key | Action |
|-----|--------|
| `<leader>bd` | Delete buffer |
| `<leader>bw` | Wipeout buffer |

### mini.diff
Git diff signs in sign column.

| Key | Action |
|-----|--------|
| `<leader>go` | Toggle diff overlay |

### mini.sessions
Session management.

| Key | Action |
|-----|--------|
| `<leader>ss` | Save session |
| `<leader>sl` | Load/select session |

### mini.animate
Smooth animations for cursor, scroll, resize, window open/close.

### mini.cursorword
Highlights all instances of word under cursor.
- Disabled in: neo-tree, lazy, mason, starter

---

## All Keymaps by Category

### General
| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | Normal | Clear search highlight |
| `n` | Normal | Next search result (centered) |
| `N` | Normal | Previous search result (centered) |
| `<C-d>` | Normal | Scroll down (centered) |
| `<C-u>` | Normal | Scroll up (centered) |
| `<leader>qq` | Normal | Quit all |
| `<leader>l` | Normal | Open Lazy (package manager) |

### Buffers (`<leader>b`)
| Key | Action |
|-----|--------|
| `<leader>bb` | Switch to other buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Delete buffer and window |
| `<leader>bo` | Delete other buffers |
| `<leader>bw` | Wipeout buffer |
| `<leader>fn` | New buffer |

### Windows (`<leader>w` and `<C-*>`)
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows |
| `<C-Up/Down/Left/Right>` | Resize windows |
| `<leader>wh/j/k/l` | Navigate windows |
| `<leader>ws` | Split horizontal |
| `<leader>wv` | Split vertical |
| `<leader>wd` | Delete window |
| `<leader>wq` | Close window |
| `<leader>wo` | Close other windows |
| `<leader>w=` | Equal window sizes |
| `<leader>w\|` | Max width |
| `<leader>w_` | Max height |

### Tabs (`<leader>t`)
| Key | Action |
|-----|--------|
| `<leader>tn` | New tab |
| `<leader>td` | Close tab |
| `<leader>t]` | Next tab |
| `<leader>t[` | Previous tab |
| `<leader>to` | Close other tabs |

### Find/Search (`<leader>f` and `<leader>s`)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Resume picker |
| `<leader>ft` | Find TODOs |
| `<leader><leader>` | Find files |
| `<leader>sr` | Search and replace (grug-far) |
| `<leader>sw` | Search word under cursor |

### Git (`<leader>g`)
| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gf` | LazyGit file history |
| `<leader>gd` | Open Diffview |
| `<leader>gh` | File history (Diffview) |
| `<leader>gc` | Close Diffview |
| `<leader>go` | Toggle diff overlay (mini.diff) |

### Code (`<leader>c`)
| Key | Action |
|-----|--------|
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format code |
| `<leader>cj` | Format JSON (jq) |
| `<leader>cx` | Format XML (xmllint) |

### LSP (no leader)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |

### AI/Claude (`<leader>a`)
| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle Claude Code |
| `<leader>af` | Focus Claude Code |
| `<leader>as` | Send to Claude (visual) |
| `<leader>aa` | Add file to Claude |
| `<leader>am` | Select Claude model |

### Flash (Jump/Motion)
| Key | Mode | Action |
|-----|------|--------|
| `s` | n/x/o | Flash |
| `S` | n/x/o | Flash Treesitter |
| `r` | o | Remote Flash |
| `R` | o/x | Treesitter Search |
| `<C-s>` | c | Toggle Flash Search |

### TODO Comments
| Key | Action |
|-----|--------|
| `]t` | Next TODO |
| `[t` | Previous TODO |
| `<leader>ft` | Find TODOs |

### Yank (`<leader>y`)
| Key | Action |
|-----|--------|
| `<leader>yf` | Copy file path |
| `<leader>yl` | Copy file path with line numbers |

### UUID (`<leader>u`)
| Key | Mode | Action |
|-----|------|--------|
| `<leader>ut` | Normal | Toggle UUID highlighting |
| `<C-u>` | Insert | Insert UUID v4 |

### File Navigation
| Key | Action |
|-----|--------|
| `-` | Open parent directory (oil.nvim) |
| `<leader>e` | Toggle explorer (neo-tree) |

### Visual Mode
| Key | Action |
|-----|--------|
| `J` | Move selection down |
| `K` | Move selection up |
| `<` | Indent left (stays in visual) |
| `>` | Indent right (stays in visual) |
| `p` | Paste without overwriting register |

### Completion (blink.cmp)
| Key | Action |
|-----|--------|
| `<C-j>` | Select next item |
| `<C-k>` | Select previous item |
| `<Tab>` | Select next item |
| `<S-Tab>` | Select previous item |
| `<CR>` | Accept completion |

---

## Leader Key Groups Summary

| Prefix | Group |
|--------|-------|
| `<leader>a` | AI (Claude) |
| `<leader>b` | Buffer |
| `<leader>c` | Code |
| `<leader>f` | Find |
| `<leader>g` | Git |
| `<leader>q` | Quit |
| `<leader>R` | REST |
| `<leader>s` | Search/Sessions |
| `<leader>t` | Tabs |
| `<leader>u` | UUID |
| `<leader>w` | Window |
| `<leader>y` | Yank |
