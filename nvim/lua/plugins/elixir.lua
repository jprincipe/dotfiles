return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lexical = {
          -- Elixir Expert (official Elixir language server)
          -- https://github.com/elixir-lang/expert
          -- NOTE: lspconfig calls this "lexical" but we use the "expert" Mason package/binary
          -- mason = false prevents auto-installing the separate "lexical" Mason package
          --
          -- Filetypes covered:
          --   - elixir: .ex, .exs files
          --   - eelixir: .eex files (Embedded Elixir)
          --   - heex: .heex files (HEEx templates)

          mason = false, -- Don't auto-install "lexical" package, we use "expert" instead
          cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/expert") },
          root_dir = function(fname)
            -- For umbrella projects, always use the workspace root
            local util = require("lspconfig").util
            return util.root_pattern(".workspace.exs", "mix.exs", ".git")(fname)
          end,
          filetypes = { "elixir", "eelixir", "heex" },
          settings = {},
        },
      },
    },
  },
}
