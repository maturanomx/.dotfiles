local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  -- installing lazy.nvim
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    {
      'catppuccin/nvim',
      lazy = false,
      name = 'catppuccin',
      opts = { flavour = 'mocha', transparent_background = true },
    },

    { 'folke/snacks.nvim', opts = { dashboard = { enabled = os.getenv 'NVIM_APP_NAME' == nil } } },

    { 'folke/tokyonight.nvim', enabled = false },

    { 'LazyVim/LazyVim', import = 'lazyvim.plugins', opts = { colorscheme = 'catppuccin' } },

    {
      'epwalsh/obsidian.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      enabled = os.getenv 'OBSIDIAN_VAULT' ~= nil,
      ft = 'markdown',
      lazy = os.getenv 'NVIM_APP_NAME' ~= 'journal',
      version = '*',
      opts = {
        daily_notes = { date_format = '%Y/%m/%Y-%m-%d', folder = 'log' },
        dir = os.getenv 'OBSIDIAN_VAULT',
      },
    },

    {
      'olimorris/codecompanion.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
      config = true,
      opts = { adapters = { opts = { proxy = 'socks5h://localhost:9090' } } },
    },

    { import = 'lazyvim.plugins.extras.lang.sql' },
    { import = 'lazyvim.plugins.extras.lang.typescript' },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = true }, -- check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
