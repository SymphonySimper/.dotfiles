{ pkgs, ... }:
let
  mkPlugin =
    { plugin, config }:
    {
      inherit plugin;
      type = "lua";
      config = if builtins.typeOf config == "path" then builtins.readFile config else config;
    };

  mkPlugins =
    plugins:
    builtins.map (
      plugin:
      if builtins.typeOf plugin == "list" then
        mkPlugin {
          plugin = builtins.elemAt plugin 0;
          config = builtins.elemAt plugin 1;
        }
      else
        plugin
    ) plugins;
in
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = # lua
      ''
        ${builtins.readFile ./config/options.lua}
        ${builtins.readFile ./config/keymaps.lua}
      '';

    plugins =
      with pkgs.vimPlugins;
      (mkPlugins [
        # telescope
        [
          telescope-nvim
          ./config/plugins/telescope.lua
        ]
        telescope-fzf-native-nvim

        [
          nvim-harpoon
          ./config/plugins/harpoon.lua
        ]
        [
          nvim-mini
          ./config/plugins/mini.lua
        ]

        # cmp
        [
          nvim-cmp
          ./config/plugins/cmp.lua
        ]
        [
          nvim-luasnip # lua
          ''
            require("luasnip").config.setup({})
          ''
        ]
        nvim-cmp-lsp
        nvim-cmp-path
        nvim-cmp-buffer
        nvim-cmp-luasnip

        [
          nvim-lspconfig
          ./config/plugins/lsp.lua
        ]
        [
          nvim-conform
          ./config/plugins/conform.lua
        ]
        [
          nvim-ts-comments # lua
          "require 'ts-comments'.setup()"
        ]
        [
          nvim-lazygit # lua
          ''
            vim.keymap.set("n", "<leader>gz", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
          ''
        ]
        [
          nvim-colorizer # lua
          "require 'colorizer'.setup()"
        ]

        # Treesitter
        [
          (nvim-treesitter.withPlugins (p: [
            # Treesitter grammars
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-markdown
            p.tree-sitter-nix
            p.tree-sitter-python

            p.tree-sitter-html
            p.tree-sitter-css
            p.tree-sitter-scss
            p.tree-sitter-javascript
            p.tree-sitter-typescript
            p.tree-sitter-svelte

            p.tree-sitter-dockerfile
            p.tree-sitter-json
            p.tree-sitter-toml
            p.tree-sitter-yaml

            p.tree-sitter-gitcommit
            p.tree-sitter-gitignore

            p.tree-sitter-vim
            p.tree-sitter-vimdoc
          ]))
          ./config/plugins/treesitter.lua
        ]

        # Common deps
        plenary-nvim
        nvim-web-devicons
      ]);

    extraPackages = with pkgs; [
      # LSP servers
      nil # nix
      lua-language-server
      bash-language-server
      svelte-language-server
      tailwindcss-language-server
      typescript-language-server
      vscode-langservers-extracted
      pyright
      ruff-lsp
      marksman

      # conform
      nixfmt-rfc-style
      shfmt
      stylua
      nodePackages.prettier
      codespell
      gawk # trim_whitespace
      gotools # goimports
    ];
  };
}
