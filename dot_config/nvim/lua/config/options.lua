-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
local o = vim.opt
local g = vim.g

o.colorcolumn = "80"
-- Vertical scroll
o.scrolloff = 8
-- Horizontal scroll
o.sidescrolloff = 8

-- Neovide
if g.neovide then
  o.guifont = "JetBrainsMono Nerd Font:h14"
  g.neovide_scale_factor = 1.0
  g.neovide_fullscreen = true
end

-- Increase lsp timeout
vim.lsp.buf.format({ timeout_ms = 5000 })
