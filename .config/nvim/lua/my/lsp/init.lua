local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

local lsp_files = {
	"lsp-installer",
	"null-ls",
	-- "rust",
}

for _, v in pairs(lsp_files) do
	require("my.lsp." .. v)
end

require("my.lsp.handlers").setup()
