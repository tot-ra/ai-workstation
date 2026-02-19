local wezterm = require("wezterm")
local config = {}
local act = wezterm.action

config.color_scheme = "Dark Pastel"
config.enable_tab_bar = true
config.use_fancy_tab_bar = true

config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 1000000
config.debug_key_events = true

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Hack Nerd Font Mono",
	"JetBrains Mono",
	"Hack",
	"PT Mono",
	"Fira Code",
})

config.font_size = 13.0
config.disable_default_key_bindings = true
config.use_ime = true -- yes emojis 🎉
config.use_dead_keys = false

config.window_decorations = "TITLE | RESIZE"
config.window_background_opacity = 0.93
config.macos_window_background_blur = 30
config.audible_bell = "Disabled"
config.check_for_updates = false

-- Enable OSC 52 clipboard integration for SSH/tmux
-- This allows remote applications (tmux, nvim) to copy to local clipboard
-- Note: enable_csi_u_key_encoding can cause duplicate characters, disabled
-- config.enable_csi_u_key_encoding = true

-- Use xterm-256color for better compatibility
-- Wezterm supports OSC 52 by default
config.term = "xterm-256color"

config.keys = {
	{ key = "v", mods = "CMD", action = wezterm.action({
		PasteFrom = "Clipboard",
	}) },

	{
		key = "c",
		mods = "CMD",
		action = wezterm.action.CopyTo("Clipboard"),
	},

	{
		key = "f",
		mods = "SUPER",
		action = act.Search({ CaseSensitiveString = "" }),
	},

	{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") },
	{ key = "Insert", mods = "CTRL", action = act.CopyTo("PrimarySelection") },

	{ key = "+", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },

	{
		key = "F12",
		action = wezterm.action.ToggleFullScreen,
	},
}
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 300
config.cursor_thickness = "250%"
config.max_fps = 75
config.animation_fps = 75
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "PT Sans", weight = "Bold" }),
	-- The size of the font in the tab bar.
	-- Default to 10. on Windows but 12.0 on other systems
	font_size = 14.0,
	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#2b5278",
	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#1a1a1a",
}

config.colors = {
	tab_bar = {
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = "#575757",
		
		-- Active tab colors
		active_tab = {
			bg_color = "#2b5278",
			fg_color = "#ffffff",
		},
		
		-- Inactive tab colors
		inactive_tab = {
			bg_color = "#1a1a1a",
			fg_color = "#808080",
		},
		
		-- Inactive tab hover colors
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
		},
		
		-- New tab button
		new_tab = {
			bg_color = "#1a1a1a",
			fg_color = "#808080",
		},
		
		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
		},
	},
}

return config
