return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lexical = {
          -- Elixir Expert (official Elixir language server)
          -- https://github.com/elixir-lang/expert
          -- Note: Expert uses 'lexical' as its lspconfig name
          -- Mason package name: 'expert' (not 'lexical')
          --
          -- Filetypes covered:
          --   - elixir: .ex, .exs files
          --   - eelixir: .eex files (Embedded Elixir)
          --   - heex: .heex files (HEEx templates)

          mason = false,
          cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/expert") },
          root_dir = require("lspconfig").util.root_pattern("mix.exs", ".git"),
          filetypes = { "elixir", "eelixir", "heex" },
          settings = {},
        },

        -- elixirls = {
        --   -- ElixirLS v0.29.3 - Production-ready Elixir LSP
        --   -- Installed via Mason: ~/.local/share/nvim/mason/bin/elixir-ls
        --
        --   -- Optimized settings for large Workspace monorepo (18 apps, 104 mix.exs files)
        --   settings = {
        --     elixirLS = {
        --       -- ========================================
        --       -- Performance & Compilation Settings
        --       -- ========================================
        --
        --       -- Disable dialyzer (slow type checker - enable only when needed)
        --       dialyzerEnabled = false,
        --
        --       -- Don't fetch dependencies automatically (use mix deps.get manually)
        --       fetchDeps = false,
        --
        --       -- Mix environment and target
        --       mixEnv = "dev",
        --       mixTarget = "host",
        --
        --       -- Project directory (root of Workspace)
        --       projectDir = ".",
        --
        --       -- ========================================
        --       -- Memory & Resource Management
        --       -- ========================================
        --
        --       -- Disable spec suggestions to reduce memory usage
        --       suggestSpecs = false,
        --
        --       -- Don't auto-insert required aliases
        --       autoInsertRequiredAlias = false,
        --
        --       -- ========================================
        --       -- Code Intelligence Settings
        --       -- ========================================
        --
        --       -- Enable signature help (function parameter hints)
        --       signatureAfterComplete = true,
        --
        --       -- No additional file extensions to watch
        --       additionalWatchedExtensions = {},
        --
        --       -- ========================================
        --       -- Build Settings
        --       -- ========================================
        --
        --       -- Automatically build on LSP start and file save
        --       -- This is required for autocomplete and go-to-definition to work
        --       autoBuild = true,
        --     },
        --   },
        --
        --   -- ========================================
        --   -- LSP Client Flags (Neovim-side)
        --   -- ========================================
        --   flags = {
        --     -- Debounce text changes to reduce LSP requests
        --     debounce_text_changes = 200, -- Wait 200ms before sending changes (balanced for responsiveness)
        --
        --     -- Enable incremental sync for better performance
        --     allow_incremental_sync = true,
        --   },
        --
        --   -- ========================================
        --   -- On Attach Callback
        --   -- ========================================
        --   on_attach = function(client, bufnr)
        --     -- Disable semantic tokens for better performance
        --     -- (Syntax highlighting from Treesitter is usually better)
        --     client.server_capabilities.semanticTokensProvider = nil
        --   end,
        -- },
      },
    },
  },
}
