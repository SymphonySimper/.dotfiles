return {
  "laytan/tailwind-sorter.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
  build = "cd formatter && npm i && npm run build",
  config = {
    on_save_enabled = true,
    on_save_pattern = {
      "*.html",
      "*.css",
      "*.js",
      "*.ts",
      "*.jsx",
      "*.tsx",
      "*.twig",
      "*.hbs",
      "*.php",
      "*.heex",
      "*.astro",
      "*.vue",
      "*.svelte",
    },
    node_path = "node",
  },
}
