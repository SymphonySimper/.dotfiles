local cmds = {
	-- To sort file contents
	[[ autocmd BufWritePre folders,fzf-folders,scripts,shell,configs :sort ]],
	-- For groff files
	[[ autocmd BufWritePost *.ms :silent !groff-ms -p "%" ]],
	[[ autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff ]],
	-- autocmd BufWritePre *.ms,*.mom :%s/^\.\(\w*\)/\.\U\1/g
	-- Open files always in new tabs
	-- [[ autocmd VimEnter * tab all ]],
	-- [[ autocmd BufAdd * exe 'tablast | tabe "' . expand( "<afile") .'"' ]],
	-- Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
	[[ autocmd BufWritePre * let currPos = getpos(".") ]],
	[[ autocmd BufWritePre * %s/\s\+$//e ]],
	[[ autocmd BufWritePre * %s/\n\+\%$//e ]],
	[[ autocmd BufWritePre *.[ch] %s/\%$/\r/e ]],
	[[ autocmd BufWritePre * cal cursor(currPos[1], currPos[2]) ]],
	[[ autocmd BufWritePre * lua vim.lsp.buf.formatting() ]],
	[[ autocmd BufRead,BufNewFile colors,dpi,urxvt :set filetype=xdefaults ]],
	[[ autocmd BufWritePost colors,dpi,urxvt :silent !gen-xresources ]],
}

for _, v in pairs(cmds) do
	vim.cmd(v)
end
