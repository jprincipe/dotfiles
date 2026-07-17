return {
  "rmagatti/auto-session",
  lazy = false,
  init = function()
    -- per auto-session docs; ensures splits/terminals survive the round-trip
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  opts = {
    suppressed_dirs = { "~/", "~/Downloads", "/" },
  },
}
