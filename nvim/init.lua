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
			"epwalsh/obsidian.nvim",
			cond = os.getenv("OBSIDIAN_VAULT") ~= nil,
			ft = "markdown",
			lazy = os.getenv("NVIM_APP_NAME") ~= "journal",
			opts = {
				daily_notes = {
					date_format = "%Y/%m/%Y-%m-%d",
					default_tags = { "dailies" },
					folder = "log",
					template = "daily.md",
				},
				dir = os.getenv("OBSIDIAN_VAULT"),
				templates = {
					folder = "_templates",
					substitutions = {
						["date:dddd, DD MMMM YYYY"] = function()
							return os.date("%A, %d %B %Y")
						end,
						["date:MMMM DD, YYYY"] = function()
							return os.date("%b %d, %Y")
						end,
						["date:WW"] = function()
							return os.date("%V")
						end,
					},
				},
			},
		},

		{
			"epwalsh/pomo.nvim",
			-- Also see "nvim-lualine/lualine.nvim" above
			opts = {
				notifiers = { { name = "Default", opts = { sticky = false } } },
			},
		},

		{
			"folke/snacks.nvim",
			opts = {
				indent = {
					chunk = {
						char = {
							corner_bottom = "╰",
							corner_top = "╭",
						},
						enabled = true,
					},
					indent = { enabled = false },
					scope = { enabled = false },
				},
				dashboard = { enabled = os.getenv("NVIM_APP_NAME") == nil },
			},
		},

		{ "folke/tokyonight.nvim", enabled = false },

		{ "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "catppuccin" } },

		{
			"nvim-lualine/lualine.nvim",
			opts = function(_, opts)
				-- overwrite section from LazyVim
				opts.sections.lualine_z = {
					function()
						local ok, pomo = pcall(require, "pomo")
						if not ok then
							return " " .. os.date("%R")
						end

						local timer = pomo.get_first_to_finish()
						if timer == nil then
							return " " .. os.date("%R")
						end

						return "󰄉 " .. tostring(timer)
					end,
				}
				return opts
			end,
		},

		-- FIXME: make proxy dynamic
		{ "olimorris/codecompanion.nvim", opts = { adapters = { opts = { proxy = "socks5h://localhost:9090" } } } },

		{ import = "lazyvim.plugins.extras.lang.sql" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
	},
	ui = { border = "rounded" },
})

vim.opt.list = false
