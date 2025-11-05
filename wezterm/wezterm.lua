local wezterm = require("wezterm")

local PATH = "/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:" .. os.getenv("PATH")
local VAULT_NAME = "brainotes"
local VAULT_PATH = os.getenv("HOME") .. "/projects/" .. VAULT_NAME

local act = wezterm.action
local config = wezterm.config_builder()
local lastWorkspace = nil

config = {
	adjust_window_size_when_changing_font_size = false,
	color_scheme = "Catppuccin Mocha",
	command_palette_bg_color = "#181825",
	hide_tab_bar_if_only_one_tab = true,
	keys = {
		{ mods = "ALT", key = "Enter", action = act.DisableDefaultAssignment },
		{ mods = "CMD|OPT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
		{ mods = "CMD|OPT", key = "RightArrow", action = act.ActivateTabRelative(1) },
		{
			mods = "CTRL|SHIFT",
			key = "j",
			action = wezterm.action_callback(function(win, pane)
				local currentWorkspace = win:active_workspace()

				if currentWorkspace == VAULT_NAME then
					win:perform_action(act.SwitchToWorkspace({ name = lastWorkspace }), pane)
				else
					lastWorkspace = currentWorkspace

					win:perform_action(
						act.SwitchToWorkspace({
							name = VAULT_NAME,
							spawn = {
								args = { "nvim", "-c", ":Obsidian today" },
								cwd = VAULT_PATH,
								set_environment_variables = {
									VAULT_NAME = VAULT_NAME,
									VAULT_PATH = VAULT_PATH,
								},
							},
						}),
						pane
					)
				end
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
		PATH = PATH,
	},
	tab_bar_at_bottom = true,
	-- use_fancy_tab_bar = false,
	window_background_opacity = 0.9,
	window_decorations = "RESIZE",
}

return config
