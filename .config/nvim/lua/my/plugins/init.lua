local plugins = {
	"packer",
	"cmp",
	"comment",
	"gitsigns",
	"nvim-tree",
	"telescope",
	"toggleterm",
	"treesitter",
	"autosave",
	"presence",
	"vimwiki",
	"gomove",
	"impatient",
	"indentline",
	"devicons",
	"autopairs",
	-- 'rust',
}

for _, v in pairs(plugins) do
	require("my.plugins." .. v)
end
