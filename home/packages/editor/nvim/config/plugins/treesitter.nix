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

          go
          gomod
          gowork
          gosum
          templ

          dockerfile
          json
          toml
          yaml

          vim
          vimdoc
          tmux
          regex

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
      ts-comments.enable = true;
    };
  };
}
