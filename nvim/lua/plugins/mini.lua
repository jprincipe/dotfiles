return {
  "nvim-mini/mini.nvim",
  lazy = false,
  priority = 100,
  config = function()
    -----------------------------------------------------------
    -- Icons
    -----------------------------------------------------------
    require("mini.icons").setup()

    -----------------------------------------------------------
    -- Statusline
    -----------------------------------------------------------
    local statusline = require("mini.statusline")
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
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local cur_mode = vim.fn.mode()
          mode = mode_names[cur_mode] or mode
          local git = statusline.section_git({ trunc_width = 75 })
          local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
          local filename = statusline.section_filename({ trunc_width = 140 })
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

    -----------------------------------------------------------
    -- Starter
    -----------------------------------------------------------
    local starter = require("mini.starter")
    starter.setup({
      header = [[
          _____                    _____
         /\    \                  /\    \
        /::\    \                /::\    \
        \:::\    \              /::::\    \
         \:::\    \            /::::::\    \
          \:::\    \          /:::/\:::\    \
           \:::\    \        /:::/__\:::\    \
           /::::\    \      /::::\   \:::\    \
  _____   /::::::\    \    /::::::\   \:::\    \
 /\    \ /:::/\:::\    \  /:::/\:::\   \:::\____\
/::\    /:::/  \:::\____\/:::/  \:::\   \:::|    |
\:::\  /:::/    \::/    /\::/    \:::\  /:::|____|
 \:::\/:::/    / \/____/  \/_____/\:::\/:::/    /
  \::::::/    /                    \::::::/    /
   \::::/    /                      \::::/    /
    \::/    /                        \::/____/
     \/____/                          ~~
]],
      items = {
        starter.sections.builtin_actions(),
        starter.sections.recent_files(5, false),
        starter.sections.recent_files(5, true),
      },
      footer = "",
    })

    -----------------------------------------------------------
    -- Comment
    -----------------------------------------------------------
    require("mini.comment").setup({})

    -----------------------------------------------------------
    -- Surround
    -----------------------------------------------------------
    require("mini.surround").setup({
      mappings = {
        add = "gsa",            -- Add surrounding (e.g., gsaiw" adds " around word)
        delete = "gsd",         -- Delete surrounding (e.g., gsd" deletes surrounding ")
        replace = "gsr",        -- Replace surrounding (e.g., gsr"' replaces " with ')
        find = "gsf",           -- Find surrounding (move to right surrounding)
        find_left = "gsF",      -- Find surrounding (move to left surrounding)
        highlight = "gsh",      -- Highlight surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    })

    -----------------------------------------------------------
    -- Indentscope
    -----------------------------------------------------------
    require("mini.indentscope").setup({
      symbol = "│",
      options = {
        try_as_border = true,
      },
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "lazy", "mason", "notify", "oil", "starter" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })

    -----------------------------------------------------------
    -- Pick
    -----------------------------------------------------------
    require("mini.pick").setup({
      mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
      },
      window = {
        config = {
          border = "rounded",
        },
      },
    })

    -----------------------------------------------------------
    -- Clue
    -----------------------------------------------------------
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        -- Leader
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        -- Built-in completion
        { mode = "i", keys = "<C-x>" },
        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },
        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        -- Window commands
        { mode = "n", keys = "<C-w>" },
        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
        -- Brackets
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
      },
      clues = {
        -- Leader groups
        { mode = "n", keys = "<Leader>a", desc = "+ai" },
        { mode = "n", keys = "<Leader>b", desc = "+buffer" },
        { mode = "n", keys = "<Leader>c", desc = "+code" },
        { mode = "n", keys = "<Leader>f", desc = "+find" },
        { mode = "n", keys = "<Leader>g", desc = "+git" },
        { mode = "n", keys = "<Leader>q", desc = "+quit" },
        { mode = "n", keys = "<Leader>R", desc = "+rest" },
        { mode = "n", keys = "<Leader>s", desc = "+search" },
        { mode = "n", keys = "<Leader>w", desc = "+window" },
        { mode = "n", keys = "<Leader>y", desc = "+yank" },
        { mode = "n", keys = "<Leader>t", desc = "+tabs" },
        -- g subgroups
        { mode = "n", keys = "gs", desc = "+surround" },
        { mode = "x", keys = "gs", desc = "+surround" },
        -- Built-in clues
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
      window = {
        delay = 300,
        config = {
          width = "auto",
          border = "rounded",
        },
      },
    })

    -----------------------------------------------------------
    -- AI (Enhanced Textobjects)
    -----------------------------------------------------------
    require("mini.ai").setup()

    -----------------------------------------------------------
    -- Move (Move lines/selections with Alt+hjkl)
    -----------------------------------------------------------
    require("mini.move").setup()

    -----------------------------------------------------------
    -- Splitjoin (Toggle split/join with gS)
    -----------------------------------------------------------
    require("mini.splitjoin").setup()

    -----------------------------------------------------------
    -- Bufremove (Delete buffers without closing windows)
    -----------------------------------------------------------
    require("mini.bufremove").setup()

    -----------------------------------------------------------
    -- Diff (Git diff in sign column)
    -----------------------------------------------------------
    require("mini.diff").setup()

    -----------------------------------------------------------
    -- Sessions (Session management)
    -----------------------------------------------------------
    require("mini.sessions").setup()

    -----------------------------------------------------------
    -- Animate (Smooth animations)
    -----------------------------------------------------------
    require("mini.animate").setup()

    -----------------------------------------------------------
    -- Cursorword (Highlight word under cursor)
    -----------------------------------------------------------
    require("mini.cursorword").setup()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "neo-tree", "lazy", "mason", "starter" },
      callback = function()
        vim.b.minicursorword_disable = true
      end,
    })
  end,
  keys = {
    -- Pick
    { "<leader>ff", function() MiniPick.builtin.files() end, desc = "Find files" },
    { "<leader>fg", function() MiniPick.builtin.grep_live() end, desc = "Live grep" },
    { "<leader>fb", function() MiniPick.builtin.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() MiniPick.builtin.help() end, desc = "Help tags" },
    { "<leader>fr", function() MiniPick.builtin.resume() end, desc = "Resume picker" },
    { "<leader><leader>", function() MiniPick.builtin.files() end, desc = "Find files" },
    -- Bufremove
    { "<leader>bd", function() MiniBufremove.delete() end, desc = "Delete buffer" },
    { "<leader>bw", function() MiniBufremove.wipeout() end, desc = "Wipeout buffer" },
    -- Diff
    { "<leader>go", function() MiniDiff.toggle_overlay() end, desc = "Toggle diff overlay" },
    -- Sessions
    { "<leader>ss", function() MiniSessions.write() end, desc = "Save session" },
    { "<leader>sl", function() MiniSessions.select() end, desc = "Load session" },
  },
}
