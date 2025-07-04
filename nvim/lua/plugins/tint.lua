return {
  "levouh/tint.nvim",
  event = "VeryLazy",
  config = function()
    require("tint").setup({
      tint = -65, -- Darken by 45 points (negative makes darker, positive makes lighter)
      saturation = 0.5, -- Desaturate to 60% of original saturation
      transforms = require("tint").transforms.SATURATE_TINT, -- Apply both saturation and tint
      highlight_ignore_patterns = { "WinSeparator", "Status.*" }, -- Don't tint these highlights
      window_ignore_function = function(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
        local filetype = vim.api.nvim_buf_get_option(bufid, "filetype")

        -- Don't tint special buffers
        return buftype ~= "" or filetype == "neo-tree" or filetype == "trouble"
      end,
    })
  end,
}
