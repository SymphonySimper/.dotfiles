{ pkgs, ... }:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
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
