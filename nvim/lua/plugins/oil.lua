return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-mini/mini.nvim" },
  lazy = false,
  opts = {
    default_file_explorer = true,
    columns = {
      "icon",
    },
    float = {
      padding = 4,
      max_width = 80,
      max_height = 30,
    },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["q"] = "actions.close",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["h"] = "actions.parent",
      ["l"] = "actions.select",
      ["<C-p>"] = "actions.preview",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-x>"] = "actions.select_split",
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == "" or not vim.uv.fs_stat(path) then
          path = vim.fn.getcwd()
        end
        require("oil").open_float(vim.fn.fnamemodify(path, ":h"))
      end,
      desc = "Explorer (current file)",
    },
    { "-", function() require("oil").open_float() end, desc = "Open parent directory" },
    { "<leader>E", function() require("oil").open_float(vim.fn.getcwd()) end, desc = "Explorer (cwd)" },
  },
}
