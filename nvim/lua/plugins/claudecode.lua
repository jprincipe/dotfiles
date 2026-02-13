return {
  "coder/claudecode.nvim",
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
  },
}
