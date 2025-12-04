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

-- Copy just the file path
local function copy_file_path()
  local relative_path = vim.fn.expand("%:.")
  vim.fn.setreg("+", relative_path)
  vim.notify("Copied: " .. relative_path, vim.log.levels.INFO)
end

-- Copy file path with line numbers
local function copy_path_with_lines()
  local relative_path = vim.fn.expand("%:.")
  local mode = vim.api.nvim_get_mode().mode

  local result
  if mode == "v" or mode == "V" or mode == "\22" then -- visual, visual-line, or visual-block
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    -- Ensure start_line <= end_line
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    if start_line == end_line then
      result = string.format("%s:%d", relative_path, start_line)
    else
      result = string.format("%s:%d-%d", relative_path, start_line, end_line)
    end
  else -- normal mode
    local current_line = vim.fn.line(".")
    result = string.format("%s:%d", relative_path, current_line)
  end

  vim.fn.setreg("+", result)
  vim.notify("Copied: " .. result, vim.log.levels.INFO)
end

vim.keymap.set({ "n", "v" }, "<leader>yf", copy_file_path, {
  noremap = true,
  silent = true,
  desc = "Copy file path",
})

vim.keymap.set({ "n", "v" }, "<leader>yl", copy_path_with_lines, {
  noremap = true,
  silent = true,
  desc = "Copy file path with line numbers",
})
