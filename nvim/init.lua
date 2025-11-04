local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- installing lazy.nvim
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	checker = { enabled = true, frequency = 86400 }, -- check for plugin updates every 24h
	dev = { path = "~/projects/lab", patterns = { "nvim" }, fallback = true },
	install = { colorscheme = { "catppuccin" } },
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
	spec = {
		{
			"catppuccin/nvim",
			name = "catppuccin",
			opts = {
				flavour = "mocha",
				integrations = { blink_cmp = true },
				transparent_background = true,
			},
		},

		{
			"folke/snacks.nvim",
			opts = {
				dashboard = { enabled = false },
				indent = {
					chunk = {
						char = {
							corner_bottom = "╰",
							corner_top = "╭",
						},
						enabled = true,
					},
				},
			},
		},

		{ "folke/tokyonight.nvim", enabled = false },

		{ "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "catppuccin" } },

		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.astro" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.sql" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },

		{
			"obsidian-nvim/obsidian.nvim",
			---@module 'obsidian'
			---@type obsidian.config
			opts = {
				completion = {
					blink = true,
					min_chars = 2,
					nvim_cmp = false,
				},
				daily_notes = {
					alias_format = "%B %-d, %Y",
					date_format = "%Y/%m/%Y-%m-%d",
					default_tags = { "daily-notes" },
					folder = "journal",
					template = "daily.md",
					workdays_only = true,
				},
				log_level = vim.log.levels.INFO,
				new_notes_location = "notes_subdir",
				notes_subdir = "notes",
				preferred_link_style = "markdown",
				templates = {
					folder = "_templates",
					substitutions = {
						["date:dddd, DD MMMM YYYY"] = function()
							return tostring(os.date("%A, %d %B %Y"))
						end,
						["date:MMMM DD, YYYY"] = function()
							return tostring(os.date("%b %d, %Y"))
						end,
						["date:WW"] = function()
							return tostring(os.date("%V"))
						end,
					},
				},
				workspaces = {
					{
						name = "brainotes",
						path = "~/projects/brainotes",
					},
				},
			},
		},
	},
	ui = { border = "rounded" },
})

-- vim: noet ci pi sts=0 sw=4 ts=4
