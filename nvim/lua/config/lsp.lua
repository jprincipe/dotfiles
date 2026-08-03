-- lsp
--------------------------------------------------------------------------------
-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
-- of how the lsp setup works in neovim 0.11+.

-- This actually just enables the lsp servers.
-- The configuration is found in the lsp folder inside the nvim config folder,
-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
vim.lsp.enable('expert')
vim.lsp.enable('lua_ls')
vim.lsp.enable('tailwindcss_ls')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    -- LSP navigation goes through fzf-lua so multiple results land in a picker with
    -- previews instead of a bare quickfix list. `lsp.jump1` is set in
    -- plugins/fzf-lua.lua, so a single result still jumps straight there.
    local fzf = function(picker)
      return function() require("fzf-lua")[picker]() end
    end

    -- LSP keymaps
    map("n", "gd", fzf("lsp_definitions"), "Go to definition")
    map("n", "gD", fzf("lsp_declarations"), "Go to declaration")
    map("n", "gr", fzf("lsp_references"), "Go to references")
    map("n", "gi", fzf("lsp_implementations"), "Go to implementation")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map({ "n", "v" }, "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format code")
  end,
})

-- Diagnostics
vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true

  -- Alternatively, customize specific options
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})
