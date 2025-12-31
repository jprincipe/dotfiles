return {
  "nvim-mini/mini.indentscope",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    symbol = "│",
    options = {
      try_as_border = true,
    },
  },
  init = function()
    -- Disable for certain filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "lazy", "mason", "notify", "oil", "starter" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
