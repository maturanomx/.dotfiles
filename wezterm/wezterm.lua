local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

config = {
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font_with_fallback({
		{ family = "Victor Mono" },
		{ family = "Symbols Nerd Font Mono", scale = 0.85 },
	}),
	font_size = 14,
	hide_tab_bar_if_only_one_tab = true,
	keys = {
		{
			mods = "CTRL|SHIFT",
			key = "j",
			action = wezterm.action_callback(function(win, pane)
				-- FIXME: already defined on `environment`
				local OBSIDIAN_VAULT = "~/projects/brainotes"

				win:perform_action(
					act.SwitchToWorkspace({
						name = "journal",
						spawn = {
							args = { "nvim", "-c", ":ObsidianToday" },
							cwd = OBSIDIAN_VAULT,
							set_environment_variables = {
								NVIM_APP_NAME = "journal",
								OBSIDIAN_VAULT = OBSIDIAN_VAULT,
							},
						},
					}),
					pane
				)
			end),
		},
	},
	set_environment_variables = {
		-- FIXME: already defined on `environment`
		PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
	},
	term = "xterm-kitty",
	window_background_opacity = 0.97,
	window_decorations = "RESIZE",
}

return config
