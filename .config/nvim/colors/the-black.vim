" Colors used
" #000000
" #111111
" #222222
" #333333
" #777777
" #aaaaaa
" #bbbbbb
" #444444
" #555555
" #FF3333

set background=dark

highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="the-black"

" --------------------------------
" Editor settings
" --------------------------------
hi Normal          guifg=#bbbbbb    guibg=NONE		gui=NONE
hi Cursor          guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi CursorLine      guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi LineNr          guifg=#333333    guibg=NONE    	gui=NONE
hi CursorLineNR    guifg=#333333    guibg=NONE    	gui=NONE

" -----------------
" - Number column -
" -----------------
hi CursorColumn   guifg=NONE       guibg=NONE		gui=NONE
hi FoldColumn     guifg=#333333    guibg=NONE    	gui=NONE
hi SignColumn     guifg=#333333    guibg=NONE    	gui=NONE
hi Folded         guifg=#333333    guibg=NONE    	gui=NONE

" -------------------------
" - Window/Tab delimiters -
" -------------------------
hi VertSplit       guifg=#222222    guibg=NONE		gui=NONE
hi ColorColumn     guifg=NONE		guibg=NONE    	gui=NONE
hi TabLine         guifg=#aaaaaa    guibg=NONE    	gui=NONE
hi TabLineFill     guifg=NONE		guibg=NONE    	gui=NONE
hi TabLineSel      guifg=#bbbbbb    guibg=#222222   gui=NONE

" -------------------------------
" - File Navigation / Searching -
" -------------------------------
hi Directory       guifg=#aaaaaa    guibg=NONE       gui=NONE
hi Search          guifg=#222222    guibg=#14E882    gui=NONE
hi IncSearch       guifg=#222222    guibg=#14E882    gui=NONE

" -----------------
" - Prompt/Status -
" -----------------
hi StatusLine      guifg=#444444    guibg=NONE		gui=NONE
hi StatusLineNC    guifg=#111111    guibg=NONE    	gui=NONE
hi WildMenu        guifg=#444444    guibg=NONE    	gui=NONE
hi Question        guifg=#333333    guibg=NONE    	gui=NONE
hi Title           guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi ModeMsg         guifg=#333333    guibg=NONE    	gui=NONE
hi MoreMsg         guifg=#444444    guibg=NONE    	gui=NONE

" --------------
" - Visual aid -
" --------------
hi MatchParen      guifg=#444444    guibg=#333333   gui=NONE
hi Visual          guifg=#bbbbbb    guibg=#333333   gui=NONE
hi VisualNOS       guifg=#bbbbbb    guibg=#333333   gui=NONE
hi NonText         guifg=#000000    guibg=NONE      gui=NONE

hi Todo            guifg=#bbbbbb    guibg=NONE		gui=NONE
hi Underlined      guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Error           guifg=#FF3333    guibg=NONE    	gui=NONE
hi ErrorMsg        guifg=#FF3333    guibg=NONE    	gui=NONE
hi WarningMsg      guifg=#333333    guibg=NONE    	gui=NONE
hi Ignore          guifg=#333333    guibg=NONE    	gui=NONE
hi SpecialKey      guifg=#333333    guibg=NONE    	gui=NONE
hi WhiteSpaceChar  guifg=#333333    guibg=NONE    	gui=NONE
hi WhiteSpace      guifg=#333333    guibg=NONE    	gui=NONE

" --------------------------------
" Variable types
" --------------------------------
hi Constant        guifg=#777777    guibg=NONE		gui=NONE
hi String          guifg=#777777    guibg=NONE    	gui=NONE
hi StringDelimiter guifg=#777777    guibg=NONE    	gui=NONE
hi Character       guifg=#777777    guibg=NONE    	gui=NONE
hi Number          guifg=#777777    guibg=NONE    	gui=NONE
hi Boolean         guifg=#777777    guibg=NONE    	gui=NONE
hi Float           guifg=#777777    guibg=NONE    	gui=NONE

hi Identifier      guifg=#bbbbbb    guibg=NONE		gui=NONE
hi Function        guifg=#bbbbbb    guibg=NONE    	gui=NONE

" --------------------------------
" Language constructs
" --------------------------------
hi Statement       guifg=#bbbbbb    guibg=NONE		gui=NONE
hi Conditional     guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Repeat          guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Label           guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Operator        guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Keyword         guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Exception       guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Comment         guifg=#333333    guibg=NONE    	gui=NONE

hi Special         guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi SpecialChar     guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Tag             guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Delimiter       guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi SpecialComment  guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Debug           guifg=#bbbbbb    guibg=NONE    	gui=NONE

" ----------
" - C like -
" ----------
hi PreProc         guifg=#bbbbbb    guibg=NONE		gui=NONE
hi Include         guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Define          guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Macro           guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi PreCondit       guifg=#bbbbbb    guibg=NONE    	gui=NONE

hi Type            guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi StorageClass    guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Structure       guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi Typedef         guifg=#bbbbbb    guibg=NONE    	gui=NONE

" --------------------------------
" Diff
" --------------------------------
hi DiffAdd         guifg=#bbbbbb    guibg=NONE		gui=NONE
hi DiffChange      guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi DiffDelete      guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi DiffText        guifg=#bbbbbb    guibg=NONE    	gui=NONE

" --------------------------------
" Completion menu
" --------------------------------
hi Pmenu           guifg=#777777    guibg=NONE		gui=NONE
hi PmenuSel        guifg=#777777    guibg=NONE    	gui=NONE
hi PmenuSbar       guifg=#777777    guibg=NONE    	gui=NONE
hi PmenuThumb      guifg=#777777    guibg=NONE    	gui=NONE

" --------------------------------
" Spelling
" --------------------------------
hi SpellBad        guifg=#444444    guibg=NONE		gui=NONE
hi SpellCap        guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi SpellLocal      guifg=#bbbbbb    guibg=NONE    	gui=NONE
hi SpellRare       guifg=#bbbbbb    guibg=NONE    	gui=NONE
