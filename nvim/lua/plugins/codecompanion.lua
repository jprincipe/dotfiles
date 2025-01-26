return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { mode = { "v", "n" }, "<Leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompainion Chat Toggle" },
    { mode = { "n", "v" }, "<Leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions" },
    { mode = { "v" }, "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "CodeCompanion Chat Add" },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        deepseek = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "deepseek", -- Give this adapter a different name to differentiate it from the default ollama adapter
            schema = {
              model = {
                default = "deepseek-r1:8b",
              },
              -- num_ctx = {
              --   default = 16384,
              -- },
              -- num_predict = {
              --   default = -1,
              -- },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
    })

    local wk = require("which-key")
    wk.add({
      { "<leader>a", group = "CodeCompanion" }, -- group
    })
  end,
}
