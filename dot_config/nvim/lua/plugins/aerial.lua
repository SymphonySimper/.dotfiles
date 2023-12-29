return {
  "stevearc/aerial.nvim",
  opts = function(_, opts)
    opts.layout.min_width = 40
    opts.filter_kind = false
    opts.open_automatic = false
    opts.manage_folds = true
    opts.link_folds_to_tree = true
    opts.link_tree_to_folds = true
    opts.show_guides = true
  end,
}
