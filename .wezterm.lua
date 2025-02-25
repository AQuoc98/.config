-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }

config.animation_fps = 1
config.max_fps = 120

config.font = wezterm.font("BlexMono Nerd Font Mono")
config.font_size = 14

config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false

config.default_cursor_style = "SteadyBar"

config.window_decorations = "RESIZE"

config.color_scheme = "Solarized Dark - Patched"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 10

-- and finally, return the configuration to wezterm
return config
