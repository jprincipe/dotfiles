-- Fuzzy finder. Replaces the mini.pick / mini.extra pickers.
--
-- `mini.visits` is deliberately kept in plugins/mini.lua: it is a visit *tracker*,
-- not a picker, and it backs the frecency list behind <leader>fv below.
--
-- In-picker keys worth knowing (fzf-lua defaults, not set here):
--   <C-g>  in grep    toggle live-grep <-> fuzzy-filter the current results
--   <C-f>/<C-b>       half page down / up
--   <M-a>             toggle all
--   <M-i>/<M-h>/<M-f> toggle ignore / hidden / follow, in file pickers
--   <F1>              show every binding for the active picker
--   <F4>              toggle preview
--   <S-Up>/<S-Down>   scroll the preview
-- Live grep accepts an inline glob after ` -- `, e.g. `handle_call -- --iglob=*.ex`,
-- which is what replaced the old <leader>fG mapping.

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-mini/mini.nvim" }, -- mini.icons supplies the file icons
  cmd = "FzfLua",
  opts = function()
    local actions = require("fzf-lua.actions")

    return {
      -- Titled borders around the picker and preview. Swap for "border-fused" to
      -- get a single box with the preview glued to the prompt -- note that profile
      -- sets `winopts.border` itself, so drop the `border` below if you try it.
      "default-title",

      winopts = {
        -- Same golden-ratio centered float the mini.pick config used.
        height = 0.618,
        width = 0.618,
        row = 0.5,
        col = 0.5,
        border = "double",
        -- Preview is left at defaults: the "builtin" previewer (native buffer +
        -- treesitter, so no `bat` needed) with the "flex" layout, which sits the
        -- preview to the right when the window is wide and below when it is narrow.

        on_create = function(e)
          -- fzf runs in a *terminal* buffer, so global terminal-mode mappings apply
          -- inside the picker. smart-splits maps <C-h/j/k/l> in mode "t" for
          -- tmux-aware pane movement, which otherwise swallows fzf's own <C-j>/<C-k>
          -- list navigation and ejects the cursor out of the float. Shadow those four
          -- buffer-locally so the keys reach fzf instead. (mini.pick never hit this:
          -- it read keys itself rather than running in a terminal.)
          for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
            vim.keymap.set("t", key, key, { buffer = e.bufnr, noremap = true, nowait = true })
          end

          -- Switching away to another tmux pane and back drops the terminal buffer
          -- into normal mode, so keystrokes silently stop reaching fzf with no visible
          -- cue. fzf-lua only registers VimResized/WinClosed/ExitPre, so restore
          -- terminal mode ourselves on regaining focus.
          vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter" }, {
            buffer = e.bufnr,
            callback = function()
              if vim.api.nvim_get_current_buf() ~= e.bufnr then return end
              if vim.bo[e.bufnr].buftype ~= "terminal" then return end
              -- Guard against racing fzf-lua's own `stopinsert` while it closes.
              if vim.api.nvim_get_mode().mode ~= "t" then vim.cmd("startinsert") end
            end,
          })
        end,
      },

      -- Derive fzf's colors from the active colorscheme's highlight groups instead
      -- of hardcoding a palette, so the picker follows the theme.
      fzf_colors = true,

      keymap = {
        fzf = {
          true, -- inherit fzf-lua's defaults, then override
          -- Page the result list with <C-u>/<C-d>, matching vim and tmux, instead
          -- of fzf-lua's <C-f>/<C-b>. Note <C-d> was `delete-char/eof`, which
          -- aborts fzf when the query is empty -- no longer possible by accident.
          ["ctrl-d"] = "half-page-down",
          ["ctrl-u"] = "half-page-up",
          -- Hand <C-f>/<C-b> back to fzf's native readline character motion.
          ["ctrl-f"] = "forward-char",
          ["ctrl-b"] = "backward-char",
          -- <C-u> used to clear the query (`unix-line-discard`); keep a way to do
          -- that. <C-w> still deletes a word backwards.
          ["alt-u"] = "clear-query",
        },
      },

      actions = {
        files = {
          true, -- `[1] == true` inherits the default enter/split/vsplit/tab binds
          -- mini.pick sent marked items to the quickfix list on <C-q>; keep that.
          -- fzf-lua's own <M-q> keeps working via the inheritance above.
          ["ctrl-q"] = actions.file_sel_to_qf,
        },
      },

      -- NOTE: buffer-delete stays on fzf-lua's native <C-x>. It deliberately does
      -- NOT get a <C-d> alias any more -- <C-d> pages the list now, and deleting a
      -- buffer when you meant to scroll is not a recoverable mistake.

      lsp = {
        jump1 = true, -- skip the picker when a symbol has exactly one result
        code_actions = { previewer = "codeaction_native" },
      },
    }
  end,
  keys = {
    -----------------------------------------------------------
    -- Find
    -----------------------------------------------------------
    -- `global` is the unified prompt: a bare query searches files, `$` switches to
    -- buffers, `@` to document symbols and `#` to workspace symbols, all without
    -- leaving the picker.
    { "<leader><space>", function() require("fzf-lua").global() end,                     desc = "Find (global)" },
    { "<leader>ff",      function() require("fzf-lua").files() end,                      desc = "Find files" },
    { "<leader>fg",      function() require("fzf-lua").live_grep() end,                  desc = "Live grep" },
    { "<leader>fb",      function() require("fzf-lua").buffers() end,                    desc = "Buffers" },
    { "<leader>fc",      function() require("fzf-lua").grep_cword() end,                 desc = "Find word under cursor" },
    { "<leader>fc",      function() require("fzf-lua").grep_visual() end,                desc = "Find selection",         mode = "v" },
    { "<leader>fh",      function() require("fzf-lua").helptags() end,                   desc = "Help tags" },
    { "<leader>fr",      function() require("fzf-lua").resume() end,                     desc = "Resume picker" },
    { "<leader>fo",      function() require("fzf-lua").oldfiles() end,                   desc = "Recent files" },
    { "<leader>fd",      function() require("fzf-lua").diagnostics_document() end,       desc = "Diagnostics (buffer)" },
    { "<leader>fD",      function() require("fzf-lua").diagnostics_workspace() end,      desc = "Diagnostics (workspace)" },
    { "<leader>fs",      function() require("fzf-lua").lsp_document_symbols() end,       desc = "Document symbols" },
    { "<leader>fS",      function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>fk",      function() require("fzf-lua").keymaps() end,                    desc = "Keymaps" },
    { "<leader>f:",      function() require("fzf-lua").commands() end,                   desc = "Commands" },
    { "<leader>f/",      function() require("fzf-lua").blines() end,                     desc = "Buffer lines" },
    { "<leader>f?",      function() require("fzf-lua").lines() end,                      desc = "Lines (all buffers)" },
    { "<leader>fm",      function() require("fzf-lua").marks() end,                      desc = "Marks" },
    { "<leader>f\"",     function() require("fzf-lua").registers() end,                  desc = "Registers" },

    -- Frecency, backed by mini.visits' tracked visit list.
    {
      "<leader>fv",
      function()
        local fzf = require("fzf-lua")
        -- `nil` cwd scopes to the current project; the weight blends recent+frequent.
        local paths = MiniVisits.list_paths(nil, { recency_weight = 0.5 })
        if #paths == 0 then
          return vim.notify("No tracked visits yet", vim.log.levels.INFO)
        end
        local cwd = vim.fn.getcwd()
        local relative = vim.tbl_map(function(p) return vim.fs.relpath(cwd, p) or p end, paths)
        fzf.fzf_exec(relative, {
          prompt = "Visited> ",
          previewer = "builtin",
          actions = fzf.defaults.actions.files,
          -- mini.visits already ordered these; don't let fzf re-sort on an empty query.
          fzf_opts = { ["--no-sort"] = true },
        })
      end,
      desc = "Visited files (frecency)",
    },

    -----------------------------------------------------------
    -- Git
    -----------------------------------------------------------
    { "<leader>gB", function() require("fzf-lua").git_branches() end, desc = "Git branches" },
    { "<leader>gC", function() require("fzf-lua").git_commits() end,  desc = "Git commits" },
    -- fzf-lua has no hunks picker; `git_status` (changed files, with a diff preview)
    -- is the nearest equivalent. Hunk *navigation* stays on mini.diff.
    { "<leader>gH", function() require("fzf-lua").git_status() end,   desc = "Git status (changed files)" },
  },
}
