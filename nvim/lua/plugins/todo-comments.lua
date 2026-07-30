return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    -- Was TodoQuickFix; routed through fzf-lua now that it's the project's picker.
    { "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Find todos" },
  },
}
