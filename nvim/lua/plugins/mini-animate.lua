return {
  "echasnovski/mini.animate",
  opts = function(_, opts)
    -- Enable cursor animation
    opts.cursor = {
      enable = true,
      timing = function(_, n)
        return 150 / n -- 150ms total duration
      end,
      path = require("mini.animate").gen_path.line(),
    }

    -- Keep existing LazyVim scroll/resize settings
    opts.scroll = opts.scroll or {
      enable = true,
      timing = function(_, n)
        return 150 / n
      end,
    }

    opts.resize = opts.resize or {
      enable = true,
      timing = function(_, n)
        return 50 / n
      end,
    }

    return opts
  end,
}
