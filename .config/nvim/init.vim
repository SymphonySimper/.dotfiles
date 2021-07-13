let mapleader =" "

if ! filereadable(system('echo -n "$XDG_CONFIG_HOME"/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p "$XDG_CONFIG_HOME"/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > "$XDG_CONFIG_HOME"/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

syntax on
syntax enable
filetype plugin indent on
set clipboard=unnamedplus
set number 
set incsearch
set smartindent
let g:rainbow_active = 1
let g:rustfmt_autosave = 2

hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE 
hi CursorLineNr term=bold cterm=NONE ctermfg=LightGrey ctermbg=NONE gui=NONE guifg=LightGrey guibg=NONE
hi StatusLine term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi EndOfBuffer term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

call plug#begin(system('echo -n "$XDG_CONFIG_HOME"/nvim/plugged'))

"Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
Plug 'rust-lang/rust.vim'

call plug#end()

map <leader>f :Goyo
