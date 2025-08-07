local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Font settings
config.font_size = 16
config.font = wezterm.font 'JetBrainsMono Nerd Font'

-- Colors
config.colors = {
cursor_bg = "white",
cursor_border = "white"
}

-- Appearance
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_padding = {
left = 0,
right = 0,
top = 0,
bottom = 0
}
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- Miscellaneous settings
config.max_fps = 120
config.prefer_egl = true 

return config
