-- Fade inactive nvim splits AND the whole editor when its tmux pane loses focus.
-- Configured to match the tmux inactive-pane dim: darken the background to #262B34
-- and leave the text/syntax colors unchanged (rather than fading the content), so
-- an inactive nvim window and an inactive tmux pane look identical.
-- Requires tmux `focus-events on` (already set) for FocusLost/FocusGained.
return {
  "TaDaa/vimade",
  event = "VeryLazy",
  opts = {
    -- Fade the whole editor when it loses focus (its tmux pane goes inactive).
    enablefocusfading = true,
    -- Fade ALL inactive windows, not just those showing a different buffer (default
    -- 'buffers' skips same-buffer splits, so they wouldn't dim).
    ncmode = "windows",
    -- 1.0 = no foreground fade; the dim comes entirely from the bg tint below.
    fadelevel = 1.0,
    tint = {
      -- #262B34 — the same darker background tmux gives inactive panes.
      bg = { rgb = { 38, 43, 52 }, intensity = 1.0 },
    },
    recipe = { "default", { animate = true } },
  },
}
