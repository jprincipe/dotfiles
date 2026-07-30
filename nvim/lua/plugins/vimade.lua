-- Fade the whole editor when its tmux pane loses focus. Inactive *splits* are
-- deliberately NOT dimmed during normal editing — that dim was removed to match
-- tmux, which now marks the active pane with a border color + title instead.
-- Requires tmux `focus-events on` (already set) for FocusLost/FocusGained.
return {
  "TaDaa/vimade",
  event = "VeryLazy",
  opts = {
    -- Fade the whole editor when it loses focus (its tmux pane goes inactive).
    enablefocusfading = true,
    -- 'focus' = only fade inactive windows while the :VimadeFocus command is
    -- toggled on, so ordinary splits stay undimmed. ('windows' faded every
    -- inactive split, 'buffers' — the default — every split with another buffer.)
    -- enablefocusfading is a separate option, so the whole-editor fade survives.
    ncmode = "focus",
    -- 1.0 = no foreground fade; the dim comes entirely from the bg tint below.
    fadelevel = 1.0,
    tint = {
      -- #262B34 — the same darker background tmux gives inactive panes.
      bg = { rgb = { 38, 43, 52 }, intensity = 1.0 },
    },
    recipe = { "default", { animate = true } },
  },
}
