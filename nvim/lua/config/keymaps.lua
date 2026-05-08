-- Keymaps
local map = vim.keymap.set

-- Clear search highlighting with Escape
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- Buffers (note: <leader>bd handled by mini.bufremove)
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to other buffer" })
map("n", "<leader>bD", "<cmd>bdelete<CR><cmd>close<CR>", { desc = "Delete buffer and window" })
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      pcall(vim.api.nvim_buf_delete, buf, {})
    end
  end
end, { desc = "Delete other buffers" })

-- Window commands
map("n", "<leader>wd", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>wh", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to lower window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to upper window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>wq", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close other windows" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equal window sizes" })
map("n", "<leader>w|", "<C-w>|", { desc = "Max width" })
map("n", "<leader>w_", "<C-w>_", { desc = "Max height" })

-- Window navigation handled by smart-splits.nvim (tmux-aware)

-- Exit terminal mode (matches tmux C-y → copy-mode)
map("t", "<C-y>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>wr", function()
  vim.notify("Resize mode: h/j/k/l to resize, Esc to exit", vim.log.levels.INFO)
  local step = 5
  while true do
    vim.cmd("redraw")
    local key = vim.fn.getcharstr()
    if key == "h" then
      vim.cmd("vertical resize -" .. step)
    elseif key == "l" then
      vim.cmd("vertical resize +" .. step)
    elseif key == "j" then
      vim.cmd("resize -" .. step)
    elseif key == "k" then
      vim.cmd("resize +" .. step)
    else
      break
    end
  end
end, { desc = "Resize mode (h/j/k/l)" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Half-page scrolling
map("n", "<C-d>", "<C-d>", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>", { desc = "Scroll up" })

-- Keep search terms centered
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Better paste (don't overwrite register)
map("x", "p", [["_dP]], { desc = "Paste without overwriting register" })

-- New buffer
map("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New buffer" })

-- Open file:line from clipboard
map("n", "<leader>yp", function()
  local clip = vim.fn.getreg("+")
  -- Strip whitespace and newlines
  clip = clip:gsub("%s+", "")
  -- Parse file:line:col or file:line
  local file, lnum = clip:match("^(.+):(%d+):%d+$")
  if not file then
    file, lnum = clip:match("^(.+):(%d+)$")
  end
  if not file then
    file = clip
  end
  -- Try direct path first (absolute or relative to cwd)
  local path = vim.fn.fnamemodify(file, ":p")
  if vim.fn.filereadable(path) == 0 then
    -- Search for the file under cwd (handles umbrella apps, monorepos, etc.)
    local matches = vim.fn.glob(vim.fn.getcwd() .. "/**/" .. file, false, true)
    if #matches > 0 then
      path = matches[1]
    else
      vim.notify("File not found: " .. file, vim.log.levels.WARN)
      return
    end
  end
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  if lnum then
    vim.api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
    vim.cmd("normal! zz")
  end
end, { desc = "Open file:line from clipboard" })

-- Format JSON with jq
map("n", "<leader>cj", function()
  local cursor_pos = vim.fn.getcurpos()
  vim.cmd(":%!jq .")
  vim.fn.setpos(".", cursor_pos)
end, { desc = "Format JSON with jq" })

-- Format XML with xmllint
map("n", "<leader>cx", function()
  local cursor_pos = vim.fn.getcurpos()
  vim.cmd(":%!xmllint --format -")
  vim.fn.setpos(".", cursor_pos)
end, { desc = "Format XML with xmllint" })

-- Copy file path
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
  if mode == "v" or mode == "V" or mode == "\22" then
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    if start_line == end_line then
      result = string.format("%s:%d", relative_path, start_line)
    else
      result = string.format("%s:%d-%d", relative_path, start_line, end_line)
    end
  else
    local current_line = vim.fn.line(".")
    result = string.format("%s:%d", relative_path, current_line)
  end

  vim.fn.setreg("+", result)
  vim.notify("Copied: " .. result, vim.log.levels.INFO)
end

map({ "n", "v" }, "<leader>yf", copy_file_path, { noremap = true, silent = true, desc = "Copy file path" })
map({ "n", "v" }, "<leader>yl", copy_path_with_lines,
  { noremap = true, silent = true, desc = "Copy file path with line numbers" })

-- Tab keymaps defined in plugins/tabby.lua

-- Terminal toggle
local term_buf = nil
local term_win = nil

local function find_term_win()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_buf then
        return win
      end
    end
  end
  return nil
end

local function toggle_terminal()
  term_win = find_term_win()

  if term_win then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end

  local height = math.floor(vim.o.lines * 0.4)
  vim.cmd("botright " .. height .. "split")
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(0, term_buf)
  else
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
  end
  term_win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
end

map("n", "<C-/>", toggle_terminal, { desc = "Toggle terminal" })
map("t", "<C-/>", toggle_terminal, { desc = "Toggle terminal" })
map("n", "<C-_>", toggle_terminal, { desc = "Toggle terminal" })
map("t", "<C-_>", toggle_terminal, { desc = "Toggle terminal" })

-- Open file from terminal output (use gf in terminal normal mode)
local function open_file_from_terminal()
  local line = vim.api.nvim_get_current_line()
  line = line:gsub("\27%[[%d;]*m", "") -- strip ANSI escape codes

  -- Find the space-delimited token under the cursor
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local token
  for s, t, e in line:gmatch("()(%S+)()") do
    if col >= s and col < e then
      token = t
      break
    end
  end

  if not token then
    vim.notify("No file path found", vim.log.levels.WARN)
    return
  end

  -- Parse file:line:col or file:line from token
  local file, lnum
  local f, l = token:match("^(.+):(%d+):%d+")
  if not f then
    f, l = token:match("^(.+):(%d+)")
  end
  file = f or token
  lnum = l and tonumber(l) or nil
  file = file:gsub("[,;:]+$", "")

  -- Resolve relative to Neovim's CWD first, then terminal's CWD
  local fullpath = vim.fn.fnamemodify(file, ":p")
  if vim.fn.filereadable(fullpath) == 0 then
    local pid = vim.b.terminal_job_pid
    if pid then
      local output = vim.fn.system({ "lsof", "-a", "-p", tostring(pid), "-d", "cwd", "-Fn" })
      local tcwd = output:match("n(.-)\n")
      if tcwd then
        fullpath = tcwd .. "/" .. file
      end
    end
  end
  if vim.fn.filereadable(fullpath) == 0 then
    vim.notify("File not found: " .. file, vim.log.levels.WARN)
    return
  end

  -- Find a non-terminal window to open the file in
  local target_win
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype ~= "terminal" then
      target_win = win
      break
    end
  end

  if not target_win then
    vim.cmd("above split")
    target_win = vim.api.nvim_get_current_win()
  end

  vim.api.nvim_set_current_win(target_win)
  vim.cmd("edit " .. vim.fn.fnameescape(fullpath))
  if lnum then
    vim.api.nvim_win_set_cursor(target_win, { lnum, 0 })
    vim.cmd("normal! zz")
  end
end

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TerminalGf", { clear = true }),
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "gf", open_file_from_terminal, { buffer = event.buf, desc = "Open file under cursor" })
    vim.keymap.set("t", "<C-g>", function()
      vim.cmd.stopinsert()
      vim.schedule(open_file_from_terminal)
    end, { buffer = event.buf, desc = "Open file under cursor" })
  end,
})

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy" })
