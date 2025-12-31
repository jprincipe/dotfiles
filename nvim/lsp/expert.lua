-- curl -L https://github.com/elixir-lang/expert/releases/download/nightly/expert_darwin_arm64 -o ~/.local/bin/expert && chmod +x ~/.local/bin/expert
return {
  cmd = { vim.fn.expand('~/.local/bin/expert'), '--stdio' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  -- For umbrella apps: 'apps' dir only exists at root
  root_markers = { 'apps', '.git', 'mix.exs' },
}
