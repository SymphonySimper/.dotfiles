return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "astro-language-server",
      "bash-language-server",
      "beautysh",
      "html-lsp",
      "json-lsp",
      "lua-language-server",
      "marksman",
      "prettier",
      "rust-analyzer",
      "shellcheck",
      "shfmt",
      "stylua",
      "svelte-language-server",
      "tailwindcss-language-server",
      "typescript-language-server",
      -- "vue-language-server",
    })
  end,
}
