local wezterm = require("wezterm")

local HOME = os.getenv("HOME")
local PATH = "/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:" .. os.getenv("PATH")
local VAULT_NAME = "brainotes"
local VAULT_PATH = HOME .. "/projects/" .. VAULT_NAME

local act = wezterm.action
local config = wezterm.config_builder()
local lastWorkspace = nil
local W_PADDING = 3

config = {
	adjust_window_size_when_changing_font_size = false,
	color_scheme = "Catppuccin Mocha",
	command_palette_bg_color = "#181825",
	font = wezterm.font_with_fallback({ "VictorMono Nerd Font", "Symbols Nerd Font Mono" }),
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
								args = { "nvim", "-c", ":e inbox.md" },
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
	-- use_fancy_tab_bar = false,
	window_background_opacity = 0.9,
	window_decorations = "RESIZE",
	window_padding = { bottom = W_PADDING, left = W_PADDING, right = W_PADDING, top = W_PADDING },
}

local function get_working_task()
	local success, result, _ = wezterm.run_child_process({
		"task",
		"rc:" .. HOME .. "/.dotfiles/task/taskrc",
		"rc.data.location:" .. HOME .. "/.private/task",
		"rc.verbose:nothing",
		"status:pending",
		"priority+",
		"-WAITING",
		"+ACTIVE",
		"export",
	}, {
		PATH = PATH,
	})

	if not success or not result then
		return ""
	end

	local tasks = wezterm.json_parse(result)

	if #tasks == 0 then
		return ""
	elseif #tasks == 1 then
		return tasks[1].description
	else
		return tasks[1].description .. " (" .. #tasks - 1 .. "+)"
	end
end

wezterm.on("update-status", function(window, pane)
	local segments = {
		get_working_task(),
		pane:get_domain_name(),
		window:active_workspace(),
	}

	local color_scheme = window:effective_config().resolved_palette
	-- `wezterm.color.parse` returns a Color object, which can be lighten or darken (amongst other things)
	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	local gradient_to, gradient_from = bg, bg
	gradient_from = gradient_to:lighten(0.2) -- gradient_to:darken(0.2)

	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- as many colors as segments
	)

	-- Build up the elements to send to `wezterm.format`
	local elements = {}
	local is_first = true

	for i, seg in ipairs(segments) do
		if seg and seg ~= "" then
			if is_first then
				table.insert(elements, { Background = { Color = "none" } })
			end
			table.insert(elements, { Foreground = { Color = gradient[i] } })
			table.insert(elements, { Text = "" })
			table.insert(elements, { Foreground = { Color = fg } })
			table.insert(elements, { Background = { Color = gradient[i] } })
			table.insert(elements, { Text = "  " .. seg .. "  " })

			is_first = false
		end
	end

	window:set_right_status(wezterm.format(elements))
end)

return config
