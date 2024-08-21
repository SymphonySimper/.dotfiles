local lspconfig = require("lspconfig")

local servers = {
	"nil_ls",
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

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

for _, server in pairs(servers) do
	if type(server) == "string" then
		lspconfig[server].setup({
			capabilities = lsp_capabilities,
		})
	else
		local config = server[2]
		config["capabilities"] = lsp_capabilities
		lspconfig[server[1]].setup(config)
	end
end

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
