-- Unified navigation and resizing across Neovim splits and herdr panes.
--
-- Replaces smart-splits.nvim plus three pieces of local glue: a hand-written
-- `smart-splits/mux/herdr.lua` backend (smart-splits ships kitty/tmux/wezterm/
-- zellij only and has no herdr support, so that file shadowed the plugin's own
-- namespace via runtimepath -- permanent debt with no upstream path), a
-- `herdr/bin/herdr-nav` shell script wired up as four `keys.command` entries,
-- and a buffer-local fzf-lua workaround (see keys below).
--
-- Two halves: this Lua side, and a herdr-side plugin providing the
-- `herdr-splits.nav-*` / `resize-*` actions bound in herdr/config.toml.
return {
  "lmilojevicc/herdr-splits.nvim",
  lazy = false,
  opts = {
    -- Match the previous smart-splits behavior: halt at the layout edge instead
    -- of wrapping. Both are needed -- `at_edge` governs Neovim splits, while
    -- `nav_at_edge` is read by the herdr-side bash script for plain panes.
    at_edge = "stop",
    nav_at_edge = "stop",

    -- herdr has no `plugin update`; a `plugin install` pins a commit, so the
    -- herdr-side bash scripts would sit frozen while lazy moves the Lua side
    -- forward. This reinstalls the herdr checkout at whatever commit lazy
    -- fetched, keeping the two halves byte-identical. Off by default upstream.
    auto_sync_herdr = true,
  },
  keys = {
    -- Terminal mode as well as normal: without it, navigation dies inside
    -- Neovim's own `:terminal` buffers (see the <C-/> toggle in config/keymaps),
    -- because the keys fall through to the shell instead of the plugin.
    -- The cost is that fzf-lua's picker runs in a terminal buffer too, so these
    -- would swallow its <C-j>/<C-k> list navigation -- undone buffer-locally in
    -- plugins/fzf-lua.lua's on_create.
    { "<C-h>", function() require("herdr-splits").move_cursor_left() end, mode = { "n", "t" }, desc = "Move to left pane" },
    { "<C-j>", function() require("herdr-splits").move_cursor_down() end, mode = { "n", "t" }, desc = "Move to lower pane" },
    { "<C-k>", function() require("herdr-splits").move_cursor_up() end, mode = { "n", "t" }, desc = "Move to upper pane" },
    { "<C-l>", function() require("herdr-splits").move_cursor_right() end, mode = { "n", "t" }, desc = "Move to right pane" },

    -- New capability; smart-splits' resizing was never wired up here.
    -- Normal mode only on purpose, unlike the nav keys above: alt+hjkl are live
    -- bindings in plenty of terminal programs (readline word motions, etc.), so
    -- claiming them in terminal mode would break more than it enables.
    { "<M-h>", function() require("herdr-splits").resize_left() end, desc = "Resize pane left" },
    { "<M-j>", function() require("herdr-splits").resize_down() end, desc = "Resize pane down" },
    { "<M-k>", function() require("herdr-splits").resize_up() end, desc = "Resize pane up" },
    { "<M-l>", function() require("herdr-splits").resize_right() end, desc = "Resize pane right" },
  },
}
