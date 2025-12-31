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
    },
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeAdd<cr>", desc = "Add file to Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
  },
}
