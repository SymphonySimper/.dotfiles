local keymaps = {
	-- General
	{
		":noh<CR>",
		"<esc>",
		"n",
		"No highlight",
	},

	-- Clipboard
	{
		[["+y<CR>]],
		"<leader>y",
		{
			"n",
			"v",
		},
		"Copy to system clipboard",
	},
	{
		[["+p<CR>]],
		"<leader>p",
		{
			"n",
			"v",
		},
		"Copy to system clipboard",
	},

	-- File
	{
		":w<CR>",
		"<leader>w",
		{
			"n",
			"v",
		},
		"Write",
	},
	{
		":bd<CR>",
		"<leader>bd",
		{
			"n",
			"v",
		},
		"Close buffer",
	},
	{
		":q<CR>",
		"<leader>q",
		{
			"n",
			"v",
		},
		"Quit",
	},

	-- Navigation
	{
		"<C-w>h",
		"<C-h>",
		"n",
		"Focus left pane",
	},
	{
		"<C-w>l",
		"<C-l>",
		"n",
		"Focus right pane",
	},
	{
		"<C-w>k",
		"<C-k>",
		"n",
		"Focus up pane",
	},
	{
		"<C-w>j",
		"<C-j>",
		"n",
		"Focus down pane",
	},

	-- Misc
	{
		vim.diagnostic.open_float,
		"<leader>cd",
		"n",
		"Line Diagnostics",
	},
}

for _, keymap in pairs(keymaps) do
	vim.keymap.set(keymap[3], keymap[2], keymap[1], { desc = keymap[4] })
end
