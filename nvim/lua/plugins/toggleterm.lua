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

      -- Terminal mode keymaps for easier navigation
      local map = LazyVim.safe_keymap_set
      map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
      map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
      map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
      map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
      map("t", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })

      -- Register terminal group with which-key
      local wk = require("which-key")
      wk.add({
        { "<leader>t", group = "terminal" },
      })
    end,
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" },
      { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Floating terminal" },
      { "<leader>t1", "<cmd>1ToggleTerm<cr>", desc = "Terminal 1" },
      { "<leader>t2", "<cmd>2ToggleTerm<cr>", desc = "Terminal 2" },
      { "<leader>t3", "<cmd>3ToggleTerm<cr>", desc = "Terminal 3" },
    },
  },
}
