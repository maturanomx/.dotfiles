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
			},
		},

		{ "folke/tokyonight.nvim", enabled = false },

		{ "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "catppuccin" } },

		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				checkbox = { checked = { scope_highlight = "@markup.strikethrough" } },
				code = { left_pad = 2, sign = false },
				heading = { sign = false },
			},
		},

		{ "olimorris/codecompanion.nvim", opts = {} },

		{ import = "lazyvim.plugins.extras.lang.astro" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.sql" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
	},
	ui = { border = "rounded" },
})

vim.opt.list = false

-- vim: noet ci pi sts=0 sw=4 ts=4
