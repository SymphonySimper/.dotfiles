return {
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   opts = {
  --     style = "night",
  --     transparent = true,
  --   },
  -- },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = false,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "catppuccin"
    end,
  },
}
