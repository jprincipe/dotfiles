return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
    end,
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      { "<leader>tt", "<cmd>ToggleTerm<cr>", mode = "t", desc = "Toggle floating terminal" },
    },
  },
}
