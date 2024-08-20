require("mini.bracketed").setup({})

require("mini.indentscope").setup({ options = { try_as_border = true }, symbol = "│" })

require("mini.move").setup({})

require("mini.pairs").setup({})

require("mini.surround").setup({
	mappings = {
		add = "gsa",
		delete = "gsd",
		find = "gsf",
		find_left = "gsF",
		highlight = "gsh",
		replace = "gsr",
		update_n_lines = "gsn",
	},
})

require("mini.files").setup({})
vim.keymap.set("n", "<leader>fm", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open mini.files (Directory of Current File)" })
vim.keymap.set("n", "<leader>fM", function()
	require("mini.files").open(vim.uv.cwd(), true)
end, { desc = "Open mini.files (cwd)" })
