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
hi TabLineFill term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi TabLine term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi TabLineSel term=bold cterm=NONE ctermfg=LightGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi VertSplit term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

call plug#begin(system('echo -n "$XDG_CONFIG_HOME"/nvim/plugged'))

" Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
Plug 'rust-lang/rust.vim'

call plug#end()

" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Switch splits with h,j,k,l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" To remove trailing white spaces
autocmd BufWritePre * :%s/\s\+$//e

map <leader>f :Goyo
