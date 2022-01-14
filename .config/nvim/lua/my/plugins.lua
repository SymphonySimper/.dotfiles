local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)

	use "wbthomason/packer.nvim"
	use "nvim-lua/popup.nvim" 
  use "nvim-lua/plenary.nvim"
	use 'ap/vim-css-color'
	use 'Jorengarenar/vim-MvVis'
	use 'unblevable/quick-scope'
	use 'tpope/vim-surround'
	use 'nvim-telescope/telescope.nvim'
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use 'nvim-telescope/telescope-media-files.nvim'
	-- cmp plugins
  use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline' 
  use 'saadparwaiz1/cmp_luasnip'  
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-nvim-lua'

	-- snippets
  use 'L3MON4D3/LuaSnip'
	use 'rafamadriz/friendly-snippets' 

	-- lsp
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'

	-- Lazy
	use {
				'vimwiki/vimwiki',
				config = function()
				vim.g.vimwiki_list = {
					{
						path = os.getenv('VIMWIKI'),
						path_html = os.getenv('XDG_DATA_HOME')..'/mywiki-html',
						diary_rel_path = 'personal/diary/',
						auto_diary_index = 1,
					},
				}
				end
	}

	use { 'dhruvasagar/vim-table-mode',  cmd = 'TableMode' }
	use { 'rust-lang/rust.vim',  ft = 'rs' }
	use { 'iamcco/markdown-preview.nvim', run = 'cd app && npm install', cmd = 'MarkdownPreview'}

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
