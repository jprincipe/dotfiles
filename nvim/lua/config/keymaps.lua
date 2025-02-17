-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = LazyVim.safe_keymap_set

-- Format the current buffer as JSON
map("n", "<leader>cj", function()
  local cursor_pos = vim.fn.getcurpos()
  vim.cmd(":%!jq .")
  vim.fn.setpos(".", cursor_pos)
end, { desc = "Format JSON with jq" })

map("n", "<leader>cx", function()
  local cursor_pos = vim.fn.getcurpos()
  vim.cmd(":%!xmllint --format -")
  vim.fn.setpos(".", cursor_pos)
end, { desc = "Format XML with xmllint" })
