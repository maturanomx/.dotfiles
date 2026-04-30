local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

local W_PADDING = 3

config = {
	adjust_window_size_when_changing_font_size = false,
	color_scheme = "Catppuccin Mocha",
	command_palette_bg_color = "#181825",
	font = wezterm.font_with_fallback({ "Victor Mono", "Symbols Nerd Font" }),
	hide_tab_bar_if_only_one_tab = true,
	leader = { mods = "CTRL", key = "Space", timeout_milliseconds = 1000 },
	macos_window_background_blur = 12,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.95,
	window_decorations = "RESIZE",
	window_padding = { bottom = W_PADDING, left = W_PADDING, right = W_PADDING, top = W_PADDING },
}

config.keys = {
	{ mods = "ALT", key = "Enter", action = act.DisableDefaultAssignment },
	{ mods = "CMD|OPT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
	{ mods = "CMD|OPT", key = "RightArrow", action = act.ActivateTabRelative(1) },
}

local workspaceManager = wezterm.plugin.require("https://github.com/ryanmsnyder/workspace-manager.wezterm")

workspaceManager.apply_to_config(config)
workspaceManager.zoxide_path = "/opt/homebrew/bin/zoxide"

wezterm.on("update-status", function(window, pane)
	local segments = {
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
