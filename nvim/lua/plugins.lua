return require('packer').startup(function(use)
  use { 'dracula/vim', as = 'dracula' }
  use { 'wbthomason/packer.nvim', opt = true }
end)
