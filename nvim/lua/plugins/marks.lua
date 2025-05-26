return {
  {
    "fnune/recall.nvim",
    config = function(_, opts)
      require("recall").setup({})
    end,
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
