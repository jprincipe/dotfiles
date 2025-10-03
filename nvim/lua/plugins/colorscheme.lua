return
-- everforest
{
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require("everforest").setup({
      background = "hard",
      transparent_background_level = 0.95,
      italics = true,
      disable_italic_comments = false,
      sign_column_background = "none",
      ui_contrast = "low",
      dim_inactive_windows = false,
      diagnostic_text_highlight = true,
      diagnostic_virtual_text = "coloured",
    })
    vim.cmd.colorscheme("everforest")
  end,
}
-- Kanagawa Paper
-- {
--   "thesimonho/kanagawa-paper.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("kanagawa-paper")
--
--     -- Set custom background colors
--     local colors = require("kanagawa-paper.colors").setup()
--     vim.api.nvim_set_hl(0, "Normal", { bg = colors.theme.ui.bg_p1 }) -- Float bg for editor
--     vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.theme.ui.bg }) -- Standard bg for dialogs
--     vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.theme.ui.bg })
--   end,
-- }
-- catppuccin
-- {
--   "catppuccin/nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("catppuccin").setup({
--       flavour = "frappe", -- latte, frappe, macchiato, mocha
--       transparent_background = true, -- disables setting the background color
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
-- }
-- monokai-pro
-- {
--   "loctvl842/monokai-pro.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("monokai-pro").setup({
--       transparent_background = true,
--       terminal_colors = true,
--       devicons = true, -- highlight the icons of `nvim-web-devicons`
--       styles = {
--         comment = { italic = true },
--         keyword = { italic = true }, -- any other keyword
--         type = { italic = true }, -- (preferred) int, long, char, etc
--         storageclass = { italic = true }, -- static, register, volatile, etc
--         structure = { italic = true }, -- struct, union, enum, etc
--         parameter = { italic = true }, -- parameter pass in function
--         annotation = { italic = true },
--         tag_attribute = { italic = true }, -- attribute of tag in reactjs
--       },
--       filter = "machine", -- classic | octagon | pro | machine | ristretto | spectrum
--     })
--     vim.cmd.colorscheme("monokai-pro")
--   end,
-- }
--  Kanagawa
-- {
--   "rebelot/kanagawa.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("kanagawa").load("wave")
--   end,
-- }
-- Nordic
-- {
--   "AlexvZyl/nordic.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("nordic").load()
--   end,
-- }
-- Nord
-- {
--   "gbprod/nord.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("nord").setup({
--       -- your configuration comes here
--       -- or leave it empty to use the default settings
--       transparent = false, -- Enable this to disable setting the background color
--       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
--       diff = { mode = "bg" }, -- enables/disables colorful backgrounds when used in diff mode. values : [bg|fg]
--       borders = true, -- Enable the border between verticaly split windows visible
--       errors = { mode = "bg" }, -- Display mode for errors and diagnostics
--       -- values : [bg|fg|none]
--       search = { theme = "vim" }, -- theme for highlighting search results
--       -- values : [vim|vscode]
--       styles = {
--         -- Style to be applied to different syntax groups
--         -- Value is any valid attr-list value for `:help nvim_set_hl`
--         comments = { italic = true },
--         keywords = { italic = true },
--         functions = {},
--         variables = {},
--
--         -- To customize lualine/bufferline
--         bufferline = {
--           current = {},
--           modified = { italic = true },
--         },
--       },
--     })
--
--     vim.cmd.colorscheme("nord")
--   end,
-- }
