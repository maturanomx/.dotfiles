local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

config = {
	color_scheme = "Catppuccin Mocha",
	hide_tab_bar_if_only_one_tab = true,
	keys = {
		{ mods = "CMD|OPT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
		{ mods = "CMD|OPT", key = "RightArrow", action = act.ActivateTabRelative(1) },
	},
	macos_window_background_blur = 15,
	set_environment_variables = {
		-- FIXME: already defined on `environment`
		PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
	},
	term = "xterm-kitty",
	window_background_opacity = 0.9,
	window_decorations = "RESIZE",
}

return config

-- vim: noet ci pi sts=0 sw=4 ts=4
