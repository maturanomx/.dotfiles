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

vim.g.mapleader = ' '

require('lazy').setup {
  spec = {
    { 'LazyVim/LazyVim', import = 'lazyvim.plugins', opts = { colorscheme = 'catppuccin-mocha' } },
    { import = 'lazyvim.plugins.extras.lang.typescript' },
    {
      'neovim/nvim-lspconfig',
      opts = {
        servers = { eslint = {} },
        setup = {
          eslint = function()
            require('lazyvim.util').on_attach(function(client)
              if client.name == 'eslint' then
                client.server_capabilities.documentFormattingProvider = true
              elseif client.name == 'tsserver' then
                client.server_capabilities.documentFormattingProvider = false
              end
            end)
          end,
        },
      },
    },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = true }, -- check for plugin updates
}
