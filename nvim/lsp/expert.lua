-- curl -L https://github.com/elixir-lang/expert/releases/download/v0.1.0-rc.6/expert_darwin_amd64 -o ~/.local/bin/expert && chmod +x ~/.local/bin/expert
return {
  cmd = { vim.fn.expand('~/.local/bin/expert'), '--stdio' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  -- For umbrella apps: 'apps' and '.git' only exist at umbrella root
  -- Don't use 'mix.exs' as each app has its own
  root_markers = { 'apps', '.git' },
}
