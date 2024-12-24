return {
  "TrevorS/uuid-nvim",
  lazy = true,
  event = "InsertEnter",  -- Load the plugin when entering insert mode
  config = function()
    local uuid = require("uuid-nvim")
    uuid.setup({
      case = "upper",
      quotes = "none",
      insert = "after",
    })

    vim.keymap.set("n", "<leader>ut", uuid.toggle_highlighting)
    vim.keymap.set("i", "<C-u>", uuid.insert_v4)
  end,
}