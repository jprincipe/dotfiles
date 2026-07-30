-- Install: grab the Burrito binary for this machine, verify, drop it on PATH.
-- Assets are expert_{linux,darwin,windows}_{amd64,arm64}; checksums in expert_checksums.txt.
--   V=v0.1.7 A=expert_linux_amd64   # or expert_darwin_arm64 on the Mac
--   curl -L -o "$A" "https://github.com/expert-lsp/expert/releases/download/$V/$A"
--   install -m 755 "$A" ~/.local/bin/expert
-- Repo moved elixir-lang/expert -> expert-lsp/expert (web redirects, the API does not).
return {
  cmd = { 'expert', '--stdio' },
  filetypes = { 'elixir', 'heex' },
  -- For umbrella apps: 'apps' and '.git' only exist at umbrella root
  -- Don't use 'mix.exs' as each app has its own
  root_markers = { 'apps', '.git' },
}
