return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "astro",
      "bash",
      "c",
      "css",
      "devicetree",
      "gitcommit",
      "gitignore",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "scss",
      "svelte",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    })
    -- opts.ignore_install = { "help" }
    -- See: https://github.com/andymass/vim-matchup
    opts.matchup = {
      enable = true,
      include_match_words = true,
    }
  end,
}
