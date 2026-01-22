local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Theme: everforest-dark with transparency
config.color_scheme = "Everforest Dark (Gogh)"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- Font settings: Maple Mono NF, size 14
config.font = wezterm.font({
  family = "Maple Mono NF",
  harfbuzz_features = { "calt", "cv01" },
})
config.font_size = 14.0
-- WezTerm doesn't have font-thicken, but we can adjust freetype settings
config.freetype_load_flags = "NO_HINTING"

-- Scrollback
config.scrollback_lines = 10000000

-- Window settings
config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.show_tab_index_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- Hide mouse while typing
config.hide_mouse_cursor_when_typing = true

-- macOS Option as Alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Cursor settings: yellow block cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0
config.colors = {
  cursor_bg = "#ffff00",
  cursor_fg = "#000000",
  cursor_border = "#ffff00",
}

-- Keybindings (macOS-style)
config.keys = {
  -- Shift+Enter sends newline (like ghostty)
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString("\n"),
  },

  -- Zoom/maximize current pane (toggle)
  {
    key = "Enter",
    mods = "CMD|SHIFT",
    action = wezterm.action.TogglePaneZoomState,
  },

  -- Splits
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- Navigate between panes
  {
    key = "[",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Prev"),
  },
  {
    key = "]",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Next"),
  },

  -- Navigate panes with arrow keys
  {
    key = "LeftArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "RightArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "UpArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "DownArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },

  -- Close pane
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },

  -- Tab navigation (standard macOS)
  {
    key = "t",
    mods = "CMD",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "{",
    mods = "CMD|SHIFT",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = "}",
    mods = "CMD|SHIFT",
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- Resize panes
  {
    key = "LeftArrow",
    mods = "CMD|CTRL",
    action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "RightArrow",
    mods = "CMD|CTRL",
    action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
  },
  {
    key = "UpArrow",
    mods = "CMD|CTRL",
    action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
  },
  {
    key = "DownArrow",
    mods = "CMD|CTRL",
    action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
  },

  -- Font size (text only, not window)
  {
    key = "=",
    mods = "CMD",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "-",
    mods = "CMD",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "0",
    mods = "CMD",
    action = wezterm.action.ResetFontSize,
  },

  -- Clear console
  {
    key = "k",
    mods = "CMD",
    action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
  },
}

-- Window save state equivalent - restore previous session
config.window_close_confirmation = "NeverPrompt"

return config
