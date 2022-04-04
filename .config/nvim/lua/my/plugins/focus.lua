local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

local focus = require("focus")

focus.setup({
	absolutenumber_unfocussed = true,
	excluded_filetypes = { "toggleterm", "NvimTree" },
	cursorline = false,
	signcolumn = false,
	cursorcolumn = false,
	-- treewidth = 30,
})
