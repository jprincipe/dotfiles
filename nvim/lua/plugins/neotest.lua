return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "jfpedroza/neotest-elixir",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-elixir")({
          -- Transform the file path by removing apps/<app_name> prefix
          post_process_command = function(cmd)
            local test_file_path_from_root = cmd[#cmd]
            local current_umbrella_app = test_file_path_from_root:match("^apps/([^/]+)")

            if not current_umbrella_app then
              -- Get the current buffer's full path
              local file_path = vim.fn.expand("%:p")

              -- Find the "apps" directory in the path
              local apps_pattern = "(.*)/apps/([^/]+)"
              local _, _, project_root, app_name = string.find(file_path, apps_pattern)

              current_umbrella_app = app_name
            end

            local current_umbrella_path = "apps/" .. current_umbrella_app
            local umbrella_relative_path_to_test = test_file_path_from_root:match("apps/" .. current_umbrella_app .. "/(.*)")

            if not umbrella_relative_path_to_test then
              umbrella_relative_path_to_test = ""
            end

            -- Log the command to see its structure
            -- vim.notify("Command before processing: " .. vim.inspect(cmd), vim.log.levels.INFO)
            -- vim.notify("test_file_path_from_root" .. vim.inspect(test_file_path_from_root), vim.log.levels.INFO)
            -- vim.notify("current_umbrella_app " .. vim.inspect(current_umbrella_app), vim.log.levels.INFO)
            -- vim.notify("test_file_path_from_root" .. vim.inspect(test_file_path_from_root), vim.log.levels.INFO)
            -- vim.notify("current_umbrella_app " .. vim.inspect(current_umbrella_app), vim.log.levels.INFO)
            -- vim.notify("current_umbrella_path " .. vim.inspect(current_umbrella_path), vim.log.levels.INFO)
            -- vim.notify("umbrella_relative_path_to_test " .. vim.inspect(umbrella_relative_path_to_test), vim.log.levels.INFO)

            local test_cmd = string.format("cd %s && mix test %s", current_umbrella_path, umbrella_relative_path_to_test)

            -- vim.notify("test_cmd: " .. vim.inspect(test_cmd), vim.log.levels.INFO)

            return test_cmd
          end,
        }),
      },
    })
  end,
}
