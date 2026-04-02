return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",            desc = "Diff view" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",    desc = "File history" },
    { "<leader>gD", "<cmd>DiffviewFileHistory<cr>",      desc = "Branch history" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>",             desc = "Close diff view" },
  },
  opts = {
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  },
}
