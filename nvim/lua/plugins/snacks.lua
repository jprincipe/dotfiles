return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
    { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume picker" },
    { "<leader>fo", function() Snacks.picker.recent() end, desc = "Recent files" },
    { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Find word under cursor" },
    { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
    { "<leader><leader>", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Find buffers" },
  },
  opts = {
    picker = {
      enabled = true,
      sources = {
        files = {
          hidden = true,
        },
      },
      win = {
        input = {
          keys = {
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
          },
        },
      },
    },
    -- Disable other snacks features we don't need
    bigfile = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
}
