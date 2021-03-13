syntax on

set number 
set incsearch
set smartindent
let g:rainbow_active = 1
let mapleader =" "

hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE 
hi CursorLineNr term=bold cterm=NONE ctermfg=LightGrey ctermbg=NONE gui=NONE guifg=LightGrey guibg=NONE
hi StatusLine term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi EndOfBuffer term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

call plug#begin('~/.vim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'

call plug#end()

map <leader>f :Goyo
