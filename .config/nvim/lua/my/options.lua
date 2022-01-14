local options = {
	backup = false,
	swapfile = false,
	showmode = false,
	syntax = "enable",
	smartindent = true,
	undofile = true,
	clipboard = "unnamedplus",
	relativenumber = true,
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	wrap = false,
	scrolloff = 8,
	sidescrolloff = 8,
	termguicolors = true,
	updatetime = 300,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
