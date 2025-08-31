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

-- Custom directory search
map("n", "<leader>sf", function()
  local dir = vim.fn.input("Search in directory: ", vim.fn.getcwd() .. "/", "dir")
  if dir ~= "" then
    LazyVim.pick("grep", { cwd = dir })()
  end
end, { desc = "Grep (Custom Dir)" })

-- Navigate between splits
map("n", "<C-]>", "<C-w>w", { desc = "Move to next split" })
map("n", "<C-[>", "<C-w>W", { desc = "Move to previous split" })

-- LSP keymaps (ensure they're always available)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
