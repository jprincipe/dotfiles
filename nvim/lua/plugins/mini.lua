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
    -- Git (commands and buffer history)
    -----------------------------------------------------------
    require("mini.git").setup()

    -----------------------------------------------------------
    -- Statusline
    -----------------------------------------------------------
    local statusline = require("mini.statusline")
    statusline.setup({
      content = {
        inactive = function()
          local filename = statusline.section_filename({ trunc_width = 140 })
          return statusline.combine_groups({
            { hl = "StatusLineNC", strings = { filename } },
          })
        end,
        active = function()
          -- Mode with full names
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
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
          mode = mode_names[vim.fn.mode()] or mode

          -- Recording macro indicator
          local rec = vim.fn.reg_recording()
          local recording = rec ~= "" and ("REC @" .. rec) or ""

          -- Git branch + summary from mini.git
          local git = statusline.section_git({ trunc_width = 40 })
          local head = vim.b.minigit_summary and vim.b.minigit_summary.head_name or ""
          if head ~= "" then git = head end

          -- Diff stats from mini.diff
          local diff = ""
          local diff_data = vim.b.minidiff_summary
          if diff_data then
            local parts = {}
            if (diff_data.add or 0) > 0 then table.insert(parts, "+" .. diff_data.add) end
            if (diff_data.change or 0) > 0 then table.insert(parts, "~" .. diff_data.change) end
            if (diff_data.delete or 0) > 0 then table.insert(parts, "-" .. diff_data.delete) end
            diff = table.concat(parts, " ")
          end

          local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
          local filename = statusline.section_filename({ trunc_width = 140 })
          local location = "%l:%c"
          local search = statusline.section_searchcount({ trunc_width = 75 })

          return statusline.combine_groups({
            { hl = mode_hl,                 strings = { mode } },
            { hl = "DiagnosticError",       strings = { recording } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
            "%<",
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=",
            { hl = "MiniStatuslineDevinfo",  strings = { diagnostics } },
            { hl = "MiniStatuslineFileinfo", strings = { search } },
            { hl = mode_hl,                  strings = { location } },
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
        width_focus = 30,
        width_nofocus = 15,
        width_preview = 80,
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
    -- Pick (Fuzzy finder)
    -----------------------------------------------------------
    require("mini.pick").setup({
      mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
        mark = "<C-x>",
        mark_all = "<C-a>",
        choose_marked = "<C-q>",
        refine = "<C-Space>",
        refine_marked = "<M-Space>",
        paste_clipboard = {
          char = "<C-v>",
          func = function()
            local clipboard = vim.fn.getreg("+")
            MiniPick.set_picker_query(vim.split(clipboard, "\n"))
          end,
        },
      },
      options = {
        use_cache = true,
      },
    })

    -----------------------------------------------------------
    -- Extra (Additional pickers and utilities)
    -----------------------------------------------------------
    require("mini.extra").setup()

    -----------------------------------------------------------
    -- Visits (Track file visits for frecency sorting)
    -----------------------------------------------------------
    require("mini.visits").setup()
  end,
  keys = {
    -- Bufremove (creates empty buffer if closing last one)
    {
      "<leader>bd",
      function()
        local buf = vim.api.nvim_get_current_buf()
        local bufs = vim.tbl_filter(function(b)
          return vim.bo[b].buflisted and vim.bo[b].buftype == ""
        end, vim.api.nvim_list_bufs())
        if #bufs <= 1 then vim.cmd("enew") end
        MiniBufremove.delete(buf)
      end,
      desc = "Delete buffer"
    },
    {
      "<leader>bw",
      function()
        local buf = vim.api.nvim_get_current_buf()
        local bufs = vim.tbl_filter(function(b)
          return vim.bo[b].buflisted and vim.bo[b].buftype == ""
        end, vim.api.nvim_list_bufs())
        if #bufs <= 1 then vim.cmd("enew") end
        MiniBufremove.wipeout(buf)
      end,
      desc = "Wipeout buffer"
    },
    -- Diff
    { "<leader>go", function() MiniDiff.toggle_overlay() end,   desc = "Toggle diff overlay" },
    -- Git
    { "<leader>gc", function() MiniGit.show_at_cursor() end,    desc = "Git show at cursor" },
    { "<leader>gl", "<cmd>Git log --oneline<cr>",               desc = "Git log" },
    { "<leader>gL", "<cmd>Git log --oneline --follow -- %<cr>", desc = "Git log (current file)" },
    { "<leader>gb", "<cmd>Git blame -- %<cr>",                  desc = "Git blame" },
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
    { "<leader>sl", function() MiniSessions.select() end,                  desc = "Load session" },
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
    -- Pick
    {
      "<leader>ff",
      function()
        local in_git = vim.fn.system("git rev-parse --is-inside-work-tree"):find("true")
        MiniPick.builtin.files({ tool = in_git and "git" or "rg" })
      end,
      desc = "Find files"
    },
    { "<leader>fg",  function() MiniPick.builtin.grep_live() end,                                  desc = "Live grep" },
    {
      "<leader>fG",
      function()
        local glob = vim.fn.input("Glob: ", "**/*.")
        if glob ~= "" then
          MiniPick.builtin.grep_live({ globs = { glob } })
        end
      end,
      desc = "Live grep (filtered)"
    },
    {
      "<leader>fb",
      function()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        table.sort(bufs, function(a, b) return a.lastused > b.lastused end)
        local buffers = {}
        for _, info in ipairs(bufs) do
          if vim.bo[info.bufnr].buftype == "" and info.name ~= "" and vim.uv.fs_stat(info.name) then
            table.insert(buffers, info.bufnr)
          end
        end
        MiniPick.builtin.buffers({ include_current = true }, {
          mappings = {
            wipeout = {
              char = "<C-d>",
              func = function()
                local items = MiniPick.get_picker_matches() or {}
                local current = items.current
                if current then
                  local buf = current.bufnr or current
                  MiniBufremove.wipeout(buf)
                  local new_items = {}
                  for _, item in ipairs(items.all or {}) do
                    local b = item.bufnr or item
                    if b ~= buf then table.insert(new_items, item) end
                  end
                  MiniPick.set_picker_items(new_items)
                end
              end,
            },
          },
          source = { items = buffers },
        })
      end,
      desc = "Buffers"
    },
    { "<leader>fh",  function() MiniPick.builtin.help() end,                                       desc = "Help tags" },
    { "<leader>fr",  function() MiniPick.builtin.resume() end,                                     desc = "Resume picker" },
    { "<leader>fo",  function() MiniExtra.pickers.oldfiles() end,                                  desc = "Recent files" },
    { "<leader>fv",  function() MiniExtra.pickers.visit_paths() end,                               desc = "Visited files (frecency)" },
    { "<leader>fc",  function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, desc = "Find word under cursor" },
    { "<leader>fd",  function() MiniExtra.pickers.diagnostic() end,                                desc = "Diagnostics" },
    { "<leader>fs",  function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end,          desc = "Document symbols" },
    { "<leader>fk",  function() MiniExtra.pickers.keymaps() end,                                   desc = "Keymaps" },
    { "<leader>f:",  function() MiniExtra.pickers.commands() end,                                  desc = "Commands" },
    { "<leader>f/",  function() MiniExtra.pickers.buf_lines() end,                                 desc = "Buffer lines" },
    { "<leader>fm",  function() MiniExtra.pickers.marks() end,                                     desc = "Marks" },
    { "<leader>f\"", function() MiniExtra.pickers.registers() end,                                 desc = "Registers" },
    -- Git pickers
    { "<leader>gB",  function() MiniExtra.pickers.git_branches() end,                              desc = "Git branches" },
    { "<leader>gC",  function() MiniExtra.pickers.git_commits() end,                               desc = "Git commits" },
    { "<leader>gH",  function() MiniExtra.pickers.git_hunks() end,                                 desc = "Git hunks" },
  },
}
