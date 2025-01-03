{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.programs.nixvim.plugins.treesitter.grammars = lib.mkOption {
    description = "Treesitter grammar packages to install";
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    programs.nixvim.plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        nixGrammars = true;
        gccPackage = null;
        nodejsPackage = null;
        treesitterPackage = null;
        grammarPackages =
          with pkgs.vimPlugins.nvim-treesitter.builtGrammars;
          [
            bash

            vim
            vimdoc
            regex
            editorconfig
          ]
          ++ (builtins.map (
            pkg: pkgs.vimPlugins.nvim-treesitter.builtGrammars.${pkg}
          ) config.programs.nixvim.plugins.treesitter.grammars);

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
