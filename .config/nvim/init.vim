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

" Reduce tab length to 4 from 8
set tabstop=4
set softtabstop=4
set shiftwidth=4

let g:rustfmt_autosave = 2

set termguicolors
colorscheme the-black

call plug#begin(system('echo -n "$XDG_CONFIG_HOME"/nvim/plugged'))

Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
Plug 'rust-lang/rust.vim'
Plug 'justinmk/vim-sneak'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/fzf.vim'
Plug 'Jorengarenar/vim-MvVis'
Plug 'unblevable/quick-scope'

call plug#end()

" FZF
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' }}

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--layout=reverse --preview-window=border-sharp'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!.dart_tool/**' --glob '!.idea' --glob '!node_modules'"

" Quick-Scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
hi QuickScopePrimary guifg='#14E882' gui=underline term=bold
hi QuickScopeSecondary guifg='#FF3333' gui=underline term=bold

" -------------------- Key binds --------------------

let mapleader =" "

" This unsets the last search pattern register by hitting return
nnoremap <CR> :noh<CR><CR>

" Switch splits with h,j,k,l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Create new tab with ctrl + t
nnoremap <silent> <C-t> :tabnew<CR>

" -------------------- LEADER COMBOS --------------------
" Open goyo
map <leader>g :Goyo<CR>

" Open fzf
map <leader>s :BLines<CR>
map <leader>p :Files<CR>

" To replace string
map <leader>r :%s//g<Left><Left>

" To remove trailing white spaces
autocmd BufWritePre * :%s/\s\+$//e
