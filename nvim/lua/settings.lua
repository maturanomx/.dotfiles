local b = vim.bo
local g = vim.o
local w = vim.wo

-- globals {
g.autowrite = true
g.backup = false
g.completeopt = "menuone,noselect,preview"
g.foldlevelstart = 10
g.hidden = true
g.hlsearch = true
g.ignorecase = true
g.inccommand = "split"
g.mouse = "a"
g.path = vim.o.path .. "**"
g.scrolloff = 1
g.shortmess = vim.o.shortmess .. "Ic"
g.showmatch = true
g.showmode = false
g.sidescrolloff = 5
g.smartcase = true
g.splitbelow = true
g.splitright = true
g.termguicolors = true
g.ttimeoutlen = 100
g.wildignorecase = true
g.wildmode = "longest:lastused"
g.wrap = false
g.writebackup = false
-- g.wildchar = "<C-z>"
-- }

-- local to window {
w.cursorline = true
w.foldcolumn = "1"
w.foldmethod = "syntax"
w.number = true
w.numberwidth = 3
w.relativenumber = true
w.signcolumn = "auto"
-- }

-- local to buffer {
b.expandtab = true
b.smartindent = true
b.swapfile = false
b.textwidth = 120
b.undofile = true
-- }
