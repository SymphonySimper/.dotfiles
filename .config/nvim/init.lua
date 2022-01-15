local contents = {
	'autocmd',
	'colorscheme',
	'keymaps',
	'lsp',
	'options',
	'plugins'
}

for _, v in pairs(contents) do
	require('my.'..v)
end
