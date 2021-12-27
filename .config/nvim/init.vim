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
set relativenumber
set incsearch
set smartindent

" Reduce tab length to 4 from 8
set tabstop=4
set softtabstop=4
set shiftwidth=4

set termguicolors
colorscheme the-black

" |---------|
" | Plugins |
" |---------|

call plug#begin(system('echo -n "$XDG_CONFIG_HOME"/nvim/plugged'))

Plug 'ap/vim-css-color'
Plug 'rust-lang/rust.vim'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/fzf.vim'
Plug 'Jorengarenar/vim-MvVis'
Plug 'unblevable/quick-scope'
Plug 'dhruvasagar/vim-table-mode'
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'

call plug#end()

" |-----------------|
" | Plugin Settings |
" |-----------------|

" Rust
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

" vimwiki
let g:vimwiki_list = [{'path': "$VIMWIKI",
			\ 'path_html': "$XDG_DATA_HOME/mywiki-html",
			\ 'diary_rel_path':'personal/diary/',
			\ 'auto_diary_index':1}]

autocmd BufEnter diary.wiki :VimwikiDiaryGenerateLinks

autocmd FileType vimwiki inoremap <silent><buffer><CR>
            \ <C-]><Esc>:VimwikiReturn 3 5<CR>
autocmd FileType vimwiki inoremap <silent><buffer><C-K>
            \ <Esc>:VimwikiReturn 2 2<CR>
autocmd FileType vimwiki nnoremap <silent><buffer><leader>h
			\ <Esc>:VimwikiAll2HTML<CR>
" autocmd BufWritePost *.wiki :VimwikiAll2HTML
" calendar integration for vimwiki

au BufRead,BufNewFile *.wiki set filetype=vimwiki
:autocmd FileType vimwiki map <leader>d :VimwikiMakeDiaryNote<CR>
function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction
:autocmd FileType vimwiki map <leader>ca :call ToggleCalendar()<CR>

" |---------------|
" | Line commands |
" |---------------|

" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

" |-----------|
" | Key binds |
" |-----------|

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

" |---------------|
" | Leader combos |
" |---------------|

" Open fzf
map <leader>s :BLines<CR>

" To replace string
map <leader>r :%s//g<Left><Left>
map <leader>c :s//g<Left><Left>
map <leader>C :s//g<Left><Left><Left><Left>

" Line options
map <leader>ol :Overline<CR>
map <leader>ul :Underline<CR>
map <leader>dl :DoubleUnderline<CR>
map <leader>st :Strikethrough<CR>

" To remove trailing white spaces
autocmd BufWritePre * :%s/\s\+$//e
