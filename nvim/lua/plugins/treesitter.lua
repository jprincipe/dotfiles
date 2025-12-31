-- Treesitter (Neovim 0.11+)
-- Plugin handles parser installation, Neovim handles highlighting
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- Required: plugin does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})

    -- Install parsers
    require("nvim-treesitter").install({
      "bash",
      "c",
      "css",
      "diff",
      "elixir",
      "eex",
      "heex",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- Enable treesitter highlighting for all filetypes
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
