-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Dim inactive windows
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = vim.api.nvim_create_augroup("custom_inactive_window_dim", { clear = true }),
  callback = function()
    -- Set NormalNC for inactive windows (using much darker background than Normal)
    -- Normal uses #242933 (gray0), so we use #1E222A (black1) for more prominent dimming
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#1E222A", fg = "#d0d5dd" })
    vim.api.nvim_set_hl(0, "LineNrNC", { bg = "#1E222A", fg = "#3b4252" })
    vim.api.nvim_set_hl(0, "SignColumnNC", { bg = "#1E222A" })
  end,
})
