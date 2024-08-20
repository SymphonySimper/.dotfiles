{ pkgs, ... }:
let
  mkPlugin = plugin: config: {
    inherit plugin;
    type = "lua";
    config = if builtins.typeOf config == "path" then builtins.readFile config else config;
  };
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
      '';

    plugins = with pkgs.vimPlugins; [
      (mkPlugin harpoon2 ./config/plugins/harpoon.lua)
      (mkPlugin nvim-colorizer "require 'colorizer'.setup()")

      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        # Treesitter grammars
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-markdown
        p.tree-sitter-nix
        p.tree-sitter-python
        p.tree-sitter-regex

        p.tree-sitter-html
        p.tree-sitter-css
        p.tree-sitter-scss
        p.tree-sitter-javascript
        p.tree-sitter-typescript
        p.tree-sitter-jsdoc
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
    ];
  };
}
