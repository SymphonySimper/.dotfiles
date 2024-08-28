{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        nixGrammars = true;
        gccPackage = null;
        nodejsPackage = null;
        treesitterPackage = null;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          lua
          markdown
          nix
          python

          html
          css
          scss
          javascript
          typescript
          svelte

          dockerfile
          json
          toml
          yaml

          vim
          vimdoc

          gitcommit
          gitignore
        ];
        settings = {
          indent.enable = true;
          highlight = {
            enable = true;
            additional_vim_regex_highlighting = false;
          };
        };
      };

      ts-autotag.enable = true;
    };
    extraPlugins = [ pkgs.vimPlugins.ts-comments-nvim ];
    extraConfigLua = "require 'ts-comments'.setup()";
  };
}
