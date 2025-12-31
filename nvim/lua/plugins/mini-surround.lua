return {
  "nvim-mini/mini.surround",
  event = "VeryLazy",
  opts = {
    mappings = {
      add = "gsa",            -- Add surrounding (e.g., gsaiw" adds " around word)
      delete = "gsd",         -- Delete surrounding (e.g., gsd" deletes surrounding ")
      replace = "gsr",        -- Replace surrounding (e.g., gsr"' replaces " with ')
      find = "gsf",           -- Find surrounding (move to right surrounding)
      find_left = "gsF",      -- Find surrounding (move to left surrounding)
      highlight = "gsh",      -- Highlight surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  },
}
