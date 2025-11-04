local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

config = {
	color_scheme = "Catppuccin Mocha",
	hide_tab_bar_if_only_one_tab = true,
	keys = {
		{ mods = "CMD|OPT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
		{ mods = "CMD|OPT", key = "RightArrow", action = act.ActivateTabRelative(1) },
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
							args = { "nvim", "-c", ":Obsidian today" },
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
		{
			mods = "CTRL|SHIFT",
			key = "n",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
					end
				end),
			}),
		},
	},
	macos_window_background_blur = 15,
	set_environment_variables = {
		-- FIXME: already defined on `environment`
		PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
	},
	tab_bar_at_bottom = true,
	-- use_fancy_tab_bar = false,
	window_background_opacity = 0.9,
	window_decorations = "RESIZE",
}

return config

-- vim: noet ci pi sts=0 sw=4 ts=4
