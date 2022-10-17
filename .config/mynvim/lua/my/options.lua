local tab = 4

local options = {
	backup = false,
	swapfile = false,
	showmode = false,
	showcmd = false,
	-- Hide last satus
	laststatus = 0,
	-- Hide command bar
	ch = 0,
	showtabline = 2,
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
	-- spell check comments
	spell = true,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
