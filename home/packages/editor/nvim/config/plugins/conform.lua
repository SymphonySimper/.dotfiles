require("conform").setup({
	format_on_save = { lsp_fallback = true, timeout_ms = 3000 },
	formatters = { injected = { options = { ignore_errors = true } } },
	formatters_by_ft = {
		["*"] = { "codespell", "trim_whitespace" },
		css = { "prettier" },
		go = { { "goimports", "gofumpt" } },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "prettier" },
		lua = { "stylua" },
		nix = { "nixfmt" },
		python = { "ruff" },
		sh = { "shfmt" },
		svelte = { "prettier" },
		typescript = { "prettier" },
	},
	notify_on_error = false,
})
