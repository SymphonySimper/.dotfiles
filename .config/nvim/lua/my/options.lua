local tab = 4

local options = {
	backup = false,
	swapfile = false,
	showmode = false,
	laststatus = 0,
	showcmd = false,
	showtabline = 2,
	signcolumn = "yes",
	syntax = "enable",
	smartindent = true,
	-- undofile = true,
	clipboard = "unnamedplus",
	relativenumber = true,
	tabstop = tab,
	softtabstop = tab,
	shiftwidth = tab,
	wrap = false,
	colorcolumn = "80",
	scrolloff = 8,
	sidescrolloff = 8,
	termguicolors = true,
	updatetime = 300,
	nrformats = "alpha",
	splitright = true,
	hls = false,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
