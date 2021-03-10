scriptencoding utf-8

" vim-plug: https://github.com/junegunn/vim-plug
call plug#begin('~/.dotfiles/_vendor/vim/')

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  \| Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'

call plug#end()

let &t_ut=''  " Fix background issue with kitty
let mapleader=' '

set autoindent cindent smartindent
set backspace=indent,eol,start
set expandtab shiftwidth=2 softtabstop=2 tabstop=2
set foldmethod=syntax foldcolumn=1 foldlevelstart=10
set hidden
set incsearch ignorecase nohlsearch smartcase
set laststatus=2
set mouse=a
set nobackup nowritebackup noswapfile
set noshowmode
set nowrap textwidth=120
set number relativenumber numberwidth=3
set path+=**
set ruler
set shortmess+=Ic
set showmatch
set signcolumn=auto
set splitbelow splitright
set termguicolors
set updatetime=300
set wildcharm=<C-z>
set wildignorecase
set wildmenu
set wildmode=longest:list
set wildoptions=tagfile

syntax enable

silent! colorscheme dracula

cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!|  " Save with sudo

cnoremap <expr> <S-tab> getcmdtype() =~ "[/?]" ? "<C-t>" : "<S-tab>"
cnoremap <expr> <tab> getcmdtype() =~ "[/?]" ? "<C-g>" : "<C-z>"

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <C-\> :CocCommand explorer<CR>
nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)
nmap <leader>rn :set relativenumber!<CR>
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
nmap <silent>gy <Plug>(coc-type-definition)
nmap =j :%!python -m json.tool<CR>| " Format JSON | REVIEW: Detect filetype?

nnoremap <C-p> :Files<CR>
nnoremap <F1> <nop>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap J mzJ`z|   " Keep cursor in place when joining lines
nnoremap K <nop>
nnoremap Q <nop>

" Plugins
let g:airline_powerline_fonts=1
let g:airline_theme='dracula'
let g:coc_global_extensions=['coc-git', 'coc-eslint', 'coc-explorer', 'coc-tsserver']

autocmd! FileType fzf set laststatus=0 noshowmode noruler norelativenumber
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
