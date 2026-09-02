local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- Installing lazy.nvim
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	checker = { enabled = true, frequency = 86400 }, -- Check for plugin updates every 24h
	dev = { path = vim.env.HOME .. "/projects/lab", patterns = { "nvim" }, fallback = true },
	install = { colorscheme = { "catppuccin-nvim" } },
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
				integrations = { render_markdown = true },
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

		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
			opts = { colorscheme = "catppuccin-nvim" },
		},

		{ import = "lazyvim.plugins.extras.ai.sidekick" },
		{ import = "lazyvim.plugins.extras.formatting.prettier" },
		{ import = "lazyvim.plugins.extras.lang.astro" },
		{ import = "lazyvim.plugins.extras.lang.docker" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.sql" },
		{ import = "lazyvim.plugins.extras.lang.toml" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.linting.eslint" },

		{
			"neovim/nvim-lspconfig",
			opts = {
				servers = {
					harper_ls = {
						settings = {
							["harper-ls"] = {
								isolateEnglish = true,
								linters = {
									AvoidCurses = false,
									Dashes = false,
									EllipsisLength = false,
									FillerWords = false,
									Hedging = false,
									LongSentences = false,
									NumericRangeEnDash = false,
									OrthographicConsistency = false,
									OxfordComma = false,
									SentenceCapitalization = false,
									UseEllipsisCharacter = false,
									UseTitleCase = false,
								},
								markdown = { IgnoreLinkTitle = true },
								userDictPath = vim.fn.expand("~/.dotfiles/harper/dictionary.txt"),
							},
						},
					},
				},
			},
		},

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
			dependencies = { "nvim-lua/plenary.nvim" },
			ft = "markdown",
			cmd = "Obsidian",
			keys = {
				{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
				{ "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },
				{ "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily note" },
				{ "<leader>oD", "<cmd>Obsidian dailies<cr>", desc = "Browse daily notes" },
				{ "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links in note" },
				{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
				{ "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Open note" },
				{ "<leader>or", "<cmd>Obsidian rename<cr>", desc = "Rename note" },
				{ "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
				{ "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Find by tag" },
				{ "<leader>oT", "<cmd>Obsidian template<cr>", desc = "Insert template" },
			},
			opts = {
				checkbox = {
					order = { " ", ">", "=", "x", "/", "-" },
				},
				daily_notes = {
					date_format = "YYYY/MM/YYYY-MM-DD",
					default_tags = { "daily" },
					folder = "log",
					template = "daily.md",
				},
				legacy_commands = false,
				link = {
					format = "shortest",
					style = "markdown",
				},
				log_level = vim.log.levels.INFO,
				new_notes_location = "notes_subdir",
				note_id_func = function(title)
					if title ~= nil then
						return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
					else
						return tostring(os.time())
					end
				end,
				picker = { name = "snacks" },
				sync = {
					enabled = true,
				},
				templates = {
					folder = "_meta/templates",
				},
				workspaces = {
					{
						name = vim.env.VAULT_NAME,
						path = vim.env.VAULT_PATH,
					},
				},
			},
		},

		{
			"mfussenegger/nvim-lint",
			opts = {
				linters = {
					-- stdin linting skips config discovery; point at the global
					-- defaults explicitly (a project config in nvim's cwd still wins)
					["markdownlint-cli2"] = {
						args = { "--config", vim.fn.expand("~/.dotfiles/markdownlint/markdownlint-cli2.jsonc"), "-" },
					},
				},
				linters_by_ft = {
					-- shellcheck has no zsh dialect; `zsh -n` is the parse check
					sh = { "shellcheck" },
					zsh = { "zsh" },
				},
			},
		},

		{
			"stevearc/conform.nvim",
			opts = {
				formatters = {
					["markdownlint-cli2"] = {
						prepend_args = { "--config", vim.fn.expand("~/.dotfiles/markdownlint/markdownlint-cli2.jsonc") },
					},
				},
				formatters_by_ft = { zsh = { "shfmt" } },
			},
		},
	},
	ui = { border = "rounded" },
})

-- Prose: harper_ls owns spelling + grammar everywhere (it understands code
-- identifiers, unlike 'spell'); native spell stays off, reserved for the
-- Spanish toggle below. LazyVim's wrap_spell autocmd would re-enable spell in
-- prose filetypes, so replace it with a wrap-only version.
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("prose_wrap", { clear = true }),
			pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
			callback = function()
				vim.opt_local.wrap = true
			end,
		})
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			vim.wo[win].spell = false
		end

		local function each_harper_ns(fn)
			for id, ns in pairs(vim.diagnostic.get_namespaces()) do
				if ns.name:find("harper", 1, true) then
					fn(id)
				end
			end
		end
		local function harper_enable(enabled)
			each_harper_ns(function(id)
				vim.diagnostic.enable(enabled, { ns_id = id, bufnr = 0 })
			end)
		end
		local function harper_enabled()
			local enabled = true
			each_harper_ns(function(id)
				enabled = enabled and vim.diagnostic.is_enabled({ ns_id = id, bufnr = 0 })
			end)
			return enabled
		end

		Snacks.toggle({
			name = "Harper",
			get = harper_enabled,
			set = harper_enable,
		}):map("<leader>uH")

		Snacks.toggle({
			name = "Spanish",
			get = function()
				return vim.wo.spell and vim.bo.spelllang == "es"
			end,
			set = function(state)
				vim.opt_local.spell = state
				vim.opt_local.spelllang = state and "es" or "en"
				harper_enable(not state)
			end,
		}):map("<leader>uS")
	end,
})
