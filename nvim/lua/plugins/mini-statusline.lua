return {
  "nvim-mini/mini.statusline",
  lazy = false,
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    local statusline = require("mini.statusline")

    -- Custom mode names (full words instead of single letters)
    local mode_names = {
      n = "NORMAL",
      i = "INSERT",
      v = "VISUAL",
      V = "V-LINE",
      ["\22"] = "V-BLOCK",
      c = "COMMAND",
      R = "REPLACE",
      t = "TERMINAL",
    }

    statusline.setup({
      use_icons = true,
      content = {
        active = function()
          -- Mode with full name
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local cur_mode = vim.fn.mode()
          mode = mode_names[cur_mode] or mode

          -- Git branch only (no diff stats)
          local git = statusline.section_git({ trunc_width = 75 })

          -- LSP diagnostics
          local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })

          -- Filename
          local filename = statusline.section_filename({ trunc_width = 140 })

          -- Simple location: line:col
          local location = "%l:%c"

          return statusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git } },
            "%<",
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=",
            { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
            { hl = mode_hl, strings = { location } },
          })
        end,
      },
    })
  end,
}
