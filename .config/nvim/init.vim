if ! filereadable(system('echo -n "$XDG_CONFIG_HOME"/nvim/autoload/plug.vim'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p "$XDG_CONFIG_HOME"/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > "$XDG_CONFIG_HOME"/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

syntax on
syntax enable
set nosecure
filetype plugin indent on
set clipboard=unnamedplus
set number
set incsearch
set smartindent

" Reduce tab length to 4 from 8
set tabstop=4
set softtabstop=4
set shiftwidth=4

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
Plug 'dhruvasagar/vim-table-mode'

call plug#end()

let g:rustfmt_autosave = 2

" FZF

let $FZF_DEFAULT_OPTS = $FZF_DEFAULT_OPTS
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' }}

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Quick-Scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
hi QuickScopePrimary guifg='#14E882' gui=underline term=bold
hi QuickScopeSecondary guifg='#FF3333' gui=underline term=bold

" --------------------- Custom Commands -------------

" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

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

" To replace string
map <leader>r :%s//g<Left><Left>
map <leader>c :s//g<Left><Left>
map <leader>C :s//g<Left><Left><Left><Left>

" To remove trailing white spaces
autocmd BufWritePre * :%s/\s\+$//e
