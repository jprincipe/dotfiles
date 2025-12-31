return {
  "nvim-mini/mini.statusline",
  lazy = false,
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    require("mini.statusline").setup({
      use_icons = true,
    })
  end,
}
