-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.have_nerd_font = false

-- Number line
vim.o.number = true
vim.o.relativenumber = true

-- Scroll
vim.o.scrolloff = 8 -- Vertical scroll
vim.o.sidescrolloff = 8 -- Horizontal scroll

vim.o.undofile = false -- Turn off undofile

vim.o.foldmethod = "manual" -- Create folds with visual selection

-- UI
vim.o.cmdheight = 1 -- Hide Command line
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "80"
vim.o.wrap = false

vim.o.clipboard = ""

-- tab settings
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.termguicolors = true
