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
    require("mini.statusline").setup()

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
      pattern = { "help", "lazy", "mason", "notify", "minifiles", "starter" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
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
        { mode = "n", keys = "gs",        desc = "+surround" },
        { mode = "x", keys = "gs",        desc = "+surround" },
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
    -- Files (File explorer)
    -----------------------------------------------------------
    require("mini.files").setup({
      mappings = {
        close       = "q",
        go_in       = "l",
        go_in_plus  = "<CR>",
        go_out      = "h",
        go_out_plus = "-",
        reset       = "<BS>",
        reveal_cwd  = "@",
        show_help   = "g?",
        synchronize = "=",
        trim_left   = "<",
        trim_right  = ">",
      },
      windows = {
        preview = true,
        width_preview = 40,
      },
    })

    -----------------------------------------------------------
    -- Sessions (Session management)
    -----------------------------------------------------------
    require("mini.sessions").setup({
      autoread = false,
      autowrite = true,
    })
    -- Auto-save session on exit (uses directory name as session name)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        -- Only save if we have real buffers open (not just starter/empty)
        local dominated_ft = { "starter", "lazy", "mason", "minifiles", "" }
        local dominated_bt = { "nofile", "help", "terminal" }
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            local ft = vim.bo[buf].filetype
            local bt = vim.bo[buf].buftype
            if not vim.tbl_contains(dominated_ft, ft) and not vim.tbl_contains(dominated_bt, bt) then
              local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
              MiniSessions.write(name)
              return
            end
          end
        end
      end,
    })

    -----------------------------------------------------------
    -- Animate (Smooth animations)
    -----------------------------------------------------------
    require("mini.animate").setup({
      open = { enable = false },
      close = { enable = false },
    })
    -- Disable animations for certain filetypes
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "minifiles", "starter", "lazy", "mason" },
      callback = function()
        vim.b.minianimate_disable = true
      end,
    })

    -----------------------------------------------------------
    -- Cursorword (Highlight word under cursor)
    -----------------------------------------------------------
    require("mini.cursorword").setup()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "minifiles", "lazy", "mason", "starter" },
      callback = function()
        vim.b.minicursorword_disable = true
      end,
    })
  end,
  keys = {
    -- Bufremove (creates empty buffer if closing last one)
    {
      "<leader>bd",
      function()
        local bufs = vim.tbl_filter(function(b)
          return vim.bo[b].buflisted and vim.bo[b].buftype == ""
        end, vim.api.nvim_list_bufs())
        if #bufs <= 1 then vim.cmd("enew") end
        MiniBufremove.delete()
      end,
      desc = "Delete buffer"
    },
    {
      "<leader>bw",
      function()
        local bufs = vim.tbl_filter(function(b)
          return vim.bo[b].buflisted and vim.bo[b].buftype == ""
        end, vim.api.nvim_list_bufs())
        if #bufs <= 1 then vim.cmd("enew") end
        MiniBufremove.wipeout()
      end,
      desc = "Wipeout buffer"
    },
    -- Diff
    { "<leader>go", function() MiniDiff.toggle_overlay() end,              desc = "Toggle diff overlay" },
    -- Files
    {
      "<leader>e",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" or not vim.uv.fs_stat(path) then
          path = vim.fn.getcwd()
        end
        MiniFiles.open(path, false)
      end,
      desc = "Explorer (current file)"
    },
    {
      "-",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" or not vim.uv.fs_stat(path) then
          path = vim.fn.getcwd()
        end
        MiniFiles.open(path, false)
      end,
      desc = "Open parent directory"
    },
    { "<leader>E",  function() MiniFiles.open(vim.fn.getcwd(), false) end, desc = "Explorer (cwd)" },
    -- Sessions
    {
      "<leader>ss",
      function()
        local name = vim.fn.input("Session name: ", vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
        if name ~= "" then
          MiniSessions.write(name)
        end
      end,
      desc = "Save session"
    },
    { "<leader>sl", function() MiniSessions.select() end, desc = "Load session" },
    {
      "<leader>sR",
      function()
        local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        if MiniSessions.detected[name] then
          MiniSessions.read(name)
        else
          vim.notify("No session found for: " .. name, vim.log.levels.WARN)
        end
      end,
      desc = "Restore session (cwd)"
    },
  },
}
