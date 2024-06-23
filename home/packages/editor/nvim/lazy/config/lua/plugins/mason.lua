return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "lua-language-server",
      "shellcheck",
      "shfmt",
      "stylua",
    })
  end,
}
