return
-- sonokai
-- {
--   "sainnhe/sonokai",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     -- Optionally configure and load the colorscheme
--     -- directly inside the plugin declaration.
--     vim.g.sonokai_enable_italic = true
--     vim.cmd.colorscheme("sonokai")
--   end,
-- }
-- Kanagawa Paper
{
  "thesimonho/kanagawa-paper.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("kanagawa-paper")

    -- Set custom background colors
    local colors = require("kanagawa-paper.colors").setup()
    vim.api.nvim_set_hl(0, "Normal", { bg = colors.theme.ui.bg_p1 }) -- Float bg for editor
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.theme.ui.bg }) -- Standard bg for dialogs
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.theme.ui.bg })
  end,
  -- opts = { ... },
}
-- catppuccin
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
-- Tokyonight
-- {
--   "folke/tokyonight.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("tokyonight-storm")
--   end,
-- }
-- Ayu
-- {
--   "Shatur/neovim-ayu",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("ayu").setup({
--       mirage = true, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
--       terminal = true, -- Set to `false` to let terminal manage its own colors.
--       overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
--     })
--     vim.cmd.colorscheme("ayu")
--   end,
-- }
