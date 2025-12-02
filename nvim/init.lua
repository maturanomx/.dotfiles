vim.opt.spell = true
vim.opt.spelllang = { "en" }

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- installing lazy.nvim
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	checker = { enabled = true, frequency = 86400 }, -- check for plugin updates every 24h
	dev = { path = os.getenv("HOME") .. "/projects/lab", patterns = { "nvim" }, fallback = true },
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

		{
			"jmbuhr/otter.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				vim.api.nvim_create_autocmd({ "FileType" }, {
					pattern = { "toml" },
					group = vim.api.nvim_create_augroup("EmbedToml", {}),
					callback = function()
						require("otter").activate()
					end,
				})
			end,
		},

		{ "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "catppuccin" } },

		{ import = "lazyvim.plugins.extras.ai.sidekick" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.astro" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.sql" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },

		{
			"nvim-treesitter/nvim-treesitter",
			init = function()
				require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
					local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
					local filename = vim.fn.fnamemodify(filepath, ":t")
					return string.match(filename, ".*mise.*%.toml$") ~= nil
				end, { force = true, all = false })
			end,
		},

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
						name = os.getenv("VAULT_NAME"),
						path = tostring(os.getenv("VAULT_PATH")),
					},
				},
			},
		},
	},
	ui = { border = "rounded" },
})
