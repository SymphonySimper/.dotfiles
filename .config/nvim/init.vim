syntax on

set number 
set incsearch
set smartindent
let g:rainbow_active = 1
let mapleader =" "

call plug#begin('~/.vim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
Plug 'dylanaraps/wal.vim'

call plug#end()

colorscheme wal

map <leader>f :Goyo
