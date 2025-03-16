return
--  Kanagawa
-- {
--   "rebelot/kanagawa.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("kanagawa").load("wave")
--   end,
-- }
-- Tokyonight
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("tokyonight-storm")
  end,
}
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
--  NORD
-- {
--   { "arcticicestudio/nord-vim" },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "nord",
--     },
--   },
-- }
--   { "Mofiqul/dracula.nvim" },
--
--   -- Configure LazyVim to load dracula
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "dracula",
--     },
--   },
-- }
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
