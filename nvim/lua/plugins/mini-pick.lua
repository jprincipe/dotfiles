return {
  "nvim-mini/mini.pick",
  event = "VeryLazy",
  keys = {
    { "<leader>ff", function() MiniPick.builtin.files() end, desc = "Find files" },
    { "<leader>fg", function() MiniPick.builtin.grep_live() end, desc = "Live grep" },
    { "<leader>fb", function() MiniPick.builtin.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() MiniPick.builtin.help() end, desc = "Help tags" },
    { "<leader>fr", function() MiniPick.builtin.resume() end, desc = "Resume picker" },
    { "<leader><leader>", function() MiniPick.builtin.files() end, desc = "Find files" },
  },
  config = function()
    require("mini.pick").setup({
      mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
      },
      window = {
        config = {
          border = "rounded",
        },
      },
    })
  end,
}
