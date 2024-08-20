local lspconfig = require("lspconfig")

local servers = {
	{ "nil_ls", { settings = { Lua = {} } } },
	"lua_ls",
	"bashls",
	"rust_analyzer",
	"svelte",
	"tailwindcss",
	"tsserver",
	"html",
	"pyright",
	"ruff",
	"marksman",
}

for _, server in pairs(servers) do
	if type(server) == "string" then
		lspconfig[server].setup({})
	else
		lspconfig[server[1]].setup(server[2])
	end
end

-- nix
lspconfig.nil_ls.setup({})
lspconfig.lua_ls.setup({})

-- keymaps
local keymaps = {
	{ "n", "<leader>ca", vim.lsp.buf.code_action },
	{
		"n",
		"<leader>cr",
		vim.lsp.buf.rename,
		"Rename",
	},
	{
		"n",
		"K",
		vim.lsp.buf.hover,
		"Hover docs",
	},
	{
		"n",
		"gd",
		vim.lsp.buf.definition,
		"Goto definition",
	},
	{
		"n",
		"gi",
		vim.lsp.buf.implementation,
		"Goto implementation",
	},
	{
		"n",
		"gr",
		vim.lsp.buf.references,
		"Goto references",
	},
	{
		"n",
		"gt",
		vim.lsp.buf.type_definition,
		"Goto type definitions",
	},
	{
		"n",
		"<leader>lr",
		":LspRestart<Enter>",
		"Restart LSP",
	},
	{
		"n",
		"gK",
		vim.lsp.buf.signature_help,
		"Signature Help",
	},
	{
		"i",
		"<c-k>",
		vim.lsp.buf.signature_help,
		"Signature Help",
	},
}

for _, keymap in ipairs(keymaps) do
	vim.keymap.set(keymap[1], keymap[2], keymap[3], { desc = keymap[4] })
end
