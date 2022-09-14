local tab = 4

local options = {
	backup = false,
	swapfile = false,
	showmode = false,
	laststatus = 2,
	showcmd = false,
	showtabline = 1,
	signcolumn = "yes",
	syntax = "enable",
	smartindent = true,
	-- undofile = true,
	clipboard = "unnamedplus",
	relativenumber = true,
	number = true,
	tabstop = tab,
	softtabstop = tab,
	shiftwidth = tab,
	wrap = false,
	-- cc = "80",
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
