return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-mini/mini.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    { "<leader>gf", function() require("neogit").open({ "log", "--", vim.fn.expand("%") }) end, desc = "Neogit file history" },
  },
  opts = {
    integrations = {
      diffview = true,
    },
    graph_style = "unicode",
  },
}
