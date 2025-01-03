return {
  { "arcticicestudio/nord-vim" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nord",
    },
  },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "frappe", -- latte, frappe, macchiato, mocha
  --       styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
  --         comments = { "italic" }, -- Change the style of comments
  --         conditionals = { "italic" },
  --         loops = {},
  --         functions = {},
  --         keywords = { "italic" },
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --         -- miscs = {}, -- Uncomment to turn off hard-coded styles
  --       },
  --     })
  --
  --     vim.cmd.colorscheme("catppuccin-frappe")
  --   end,
  -- },
}
