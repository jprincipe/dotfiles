return {
  "ellisonleao/dotenv.nvim",
  config = function()
    require("dotenv").setup({
      enable_on_load = true, -- Automatically load .env on startup
    })
  end,
}
