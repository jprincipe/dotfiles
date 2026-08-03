-- Filetypes
vim.filetype.add({
  extension = {
    livemd = "markdown",
  },
})

-- Options
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Clipboard
--
-- On a headless remote box `unnamedplus` is a silent no-op: there's no
-- DISPLAY/WAYLAND_DISPLAY and no wl-copy/xclip/xsel, so nvim finds no provider and
-- yanks go nowhere. Nvim's own OSC 52 fallback doesn't kick in either, because it
-- keys on $SSH_TTY and herdr spawns panes from its persistent server rather than the
-- sshd login session, so that var isn't in the pane env.
--
-- OSC 52 writes the clipboard via a terminal escape, so the text travels
-- nvim -> herdr -> ssh -> the herdr client and lands on the *client's* clipboard.
--
-- Two ordering traps, both of which silently produce a registered-but-unused provider:
--   1. Do NOT probe with has('clipboard') to decide. That call forces nvim to resolve
--      the provider immediately and cache the result, so a g.clipboard assigned
--      afterwards is ignored -- g.clipboard reads back fine while has('clipboard')
--      stays 0. Detect the environment directly instead.
--   2. Assign g.clipboard BEFORE opt.clipboard, and clear the cached resolution, in
--      case something earlier in startup already probed.
--
-- Paste deliberately reads the unnamed register rather than querying the terminal:
-- an OSC 52 read round-trip is slow and widely unsupported, and this keeps `p`
-- working for anything yanked inside this nvim. Pasting *into* nvim from the client
-- still goes through the terminal's own paste (cmd+v), not the `+` register.
local has_native_clipboard = vim.fn.executable("pbcopy") == 1
  or vim.env.WAYLAND_DISPLAY ~= nil
  or vim.env.DISPLAY ~= nil

if not has_native_clipboard then
  local osc52 = require("vim.ui.clipboard.osc52")
  local unnamed = function()
    return vim.split(vim.fn.getreg('"'), "\n")
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = unnamed, ["*"] = unnamed },
  }
  vim.g.loaded_clipboard_provider = nil -- force re-resolution against the above
end

opt.clipboard = "unnamedplus"

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.autoread = true

-- Wrapping
opt.wrap = false

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10
opt.pumborder = "single"

-- Misc
opt.confirm = true
opt.hidden = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.mouse = "a"
opt.showmode = false
opt.laststatus = 3
opt.breakindent = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"
-- Single-line window separators (clean/thin), matching tmux's default pane borders
opt.fillchars = { eob = " ", horiz = "─", horizup = "┴", horizdown = "┬", vert = "│", vertleft = "┤", vertright = "├", verthoriz = "┼" }

-- Folding (native treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
