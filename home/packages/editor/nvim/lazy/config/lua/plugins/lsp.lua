return {
  "neovim/nvim-lspconfig",
  version = "*",
  opts = {
    servers = {
      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                -- refer: https://github.com/paolotiu/tailwind-intellisense-regex-list
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                -- { "([a-zA-Z0-9\\-:]+)" },
              },
            },
          },
        },
      },
    },
  },
}
