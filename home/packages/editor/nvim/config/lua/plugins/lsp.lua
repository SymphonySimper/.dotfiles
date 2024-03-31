return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.format.timeout_ms = 5000
  end,
}
