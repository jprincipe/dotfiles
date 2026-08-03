-- Install: grab the Burrito binary for this machine, verify, drop it on PATH.
-- Assets are expert_{linux,darwin,windows}_{amd64,arm64}; checksums in expert_checksums.txt.
--   V=v0.1.8 A=expert_linux_amd64   # or expert_darwin_arm64 on the Mac
--   curl -L -o "$A" "https://github.com/expert-lsp/expert/releases/download/$V/$A"
--   install -m 755 "$A" ~/.local/bin/expert
-- Repo moved elixir-lang/expert -> expert-lsp/expert (web redirects, the API does not).
-- Expert spawns a *second* BEAM (the "project node") to build and index the project,
-- and that node is what runs away: unbounded on this 32-core box it took ~9 cores and
-- grew past 24GB. It cannot be capped via the environment -- Expert hands the child a
-- scrubbed env with no ERL_*/ELIXIR_* vars at all (verified: 130 vars, zero of them).
--
-- So bound it from outside with a cgroup. Everything Expert spawns lands in the same
-- scope, and the BEAM reads the cgroup CPU quota and self-sizes its scheduler pool
-- (CPUQuota=200% -> schedulers_online=2), so this caps the project node too.
-- MemoryHigh throttles first; MemoryMax is the hard backstop.
local function wrap(cmd)
  if vim.uv.os_uname().sysname ~= 'Linux' or vim.fn.executable('systemd-run') ~= 1 then
    return cmd -- macOS / no systemd: fall back to the ERL_FLAGS cap below
  end
  local scoped = {
    'systemd-run', '--user', '--scope', '--quiet', '--collect',
    '-p', 'CPUQuota=200%',
    '-p', 'MemoryHigh=3G',
    '-p', 'MemoryMax=6G',
    '--',
  }
  vim.list_extend(scoped, cmd)
  return scoped
end

return {
  cmd = wrap({ 'expert', '--stdio' }),
  filetypes = { 'elixir', 'heex' },

  -- Caps the Expert server itself. Does NOT reach the project node (scrubbed env),
  -- which is why the cgroup above exists; kept as the fallback when systemd-run isn't
  -- available.
  cmd_env = { ERL_FLAGS = '+S 4:4 +SDcpu 2:2' },

  -- Root at the nearest mix.exs, i.e. per app -- NOT the workspace root.
  -- ~/dev/ef is a 44-app elixir-workspace monorepo where every app carries its own
  -- deps/ and _build/, so rooting at 'apps'/'.git' put one node in charge of all of
  -- them: ~36k indexable files (30k of it duplicated third-party code, ecto_sql
  -- indexed 148x), a 4.6GB index that never converged. Per-app is ~300-1700 files.
  -- Trade-off: cross-app go-to-definition degrades, and editing several apps means
  -- several small Expert instances instead of one huge one. Worth it.
  --
  -- A plain root_markers = { 'mix.exs' } would still root at the workspace when you
  -- open the top-level mix.exs, which is exactly the pathological case. So: refuse
  -- to attach at the workspace root, and let the per-app roots through.
  --
  -- Keyed on workspace.lock rather than an apps/ dir, because umbrellas have apps/
  -- too and Expert already handles those correctly on its own: it detects an umbrella
  -- by apps_path in mix.exs and starts a single engine for the whole thing
  -- (expert-lsp/expert#460, #462). ~/dev/ef is not an umbrella -- it declares
  -- workspace: [type: :workspace] with no apps_path -- so that detection never fires
  -- and Expert sees one plain project containing all 44 apps. Testing apps/ would
  -- therefore also refuse genuine umbrellas, the one layout upstream gets right.
  root_dir = function(bufnr, on_dir)
    local dir = vim.fs.root(vim.api.nvim_buf_get_name(bufnr), { 'mix.exs' })
    if not dir then
      return
    end
    if vim.uv.fs_stat(dir .. '/workspace.lock') then
      -- Expected, not a failure: skipping keeps one node from indexing every app.
      -- INFO + once per root, since a WARN here reads like Expert failed to start.
      _G.__expert_skipped = _G.__expert_skipped or {}
      if not _G.__expert_skipped[dir] then
        _G.__expert_skipped[dir] = true
        vim.notify(
          ('expert: skipping workspace root %s by design; open a file under apps/<app>/'):format(dir),
          vim.log.levels.INFO
        )
      end
      return
    end
    on_dir(dir)
  end,
}
