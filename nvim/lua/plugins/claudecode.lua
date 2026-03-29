--- Pick MCP config files from mcp/ and launch Claude Code with them.
--- Uses MiniPick for multi-select: <C-x> to mark, <CR> to confirm.
--- If nothing is marked, the item under the cursor is used.
local function pick_mcp_and_launch()
  local mcp_dir = vim.fn.getcwd() .. "/mcp"
  local entries = vim.fn.globpath(mcp_dir, "*.mcp.json", false, true)
  if #entries == 0 then
    vim.notify("No .mcp.json files found in mcp/", vim.log.levels.WARN)
    return
  end

  -- Map short names back to full paths
  local path_lookup = {}
  local names = {}
  for _, path in ipairs(entries) do
    local name = vim.fn.fnamemodify(path, ":t")
    path_lookup[name] = path
    table.insert(names, name)
  end

  local selected = nil
  MiniPick.start({
    source = {
      name = "MCP Configs",
      items = names,
      choose = function(chosen)
        local marked = MiniPick.get_picker_matches().marked or {}
        if #marked > 0 then
          selected = marked
        elseif chosen then
          selected = { chosen }
        end
      end,
    },
  })

  -- Picker is fully closed at this point
  if not selected or #selected == 0 then return end
  local paths = {}
  for _, name in ipairs(selected) do
    table.insert(paths, vim.fn.fnameescape(path_lookup[name]))
  end
  vim.cmd("ClaudeCode --mcp-config " .. table.concat(paths, " "))
end

return {
  "coder/claudecode.nvim",
  enabled = false,
  opts = {
    terminal = {
      provider = "auto",
      auto_close = true,
    },
    track_selection = true,

    diff_opts = {
      layout = "vertical",
      open_in_new_tab = false,
      auto_close_on_accept = true,
    },
  },
  keys = {
    { "<C-\\>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "Toggle Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeAdd<cr>", desc = "Add file to Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
    { "<leader>aM", pick_mcp_and_launch, desc = "Claude Code with MCP picker" },
  },
}
