local tab = 4

local options = {
	backup = false,
	swapfile = false,
	showmode = false,
	syntax = "enable",
	smartindent = true,
	-- undofile = true,
	clipboard = "unnamedplus",
	relativenumber = true,
	tabstop = tab,
	softtabstop = tab,
	shiftwidth = tab,
	wrap = false,
	scrolloff = 8,
	sidescrolloff = 8,
	termguicolors = true,
	updatetime = 300,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
