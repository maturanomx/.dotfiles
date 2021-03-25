local map = vim.api.nvim_set_keymap

vim.g.mapleader = ' '

local options = { noremap = true }

map('', '<C-h>', '<C-w>h', options)
map('', '<C-j>', '<C-w>j', options)
map('', '<C-k>', '<C-w>k', options)
map('', '<C-l>', '<C-w>l', options)
map('', '<C-n>', ':bnext<CR>', options)
map('', '<C-p>', ':bprev<CR>', options)
map('', '<F1>', '', options)

map('c', '<S-Tab>', 'getcmdtype() =~ "[/?]" ? "<C-t>" : "<S-Tab>"', { noremap = true, expr = true })
map('c', '<Tab>', 'getcmdtype() =~ "[/?]" ? "<C-g>" : "<C-z>"', { noremap = true, expr = true })

map('i', '<F1>', '', options)
map('i', 'jk', '<Esc>', options)

map('n', '<C-l>', ':nohlsearch<CR>', options)
