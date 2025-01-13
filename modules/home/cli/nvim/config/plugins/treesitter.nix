{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkGrammars =
    grammars: builtins.map (grammar: pkgs.vimPlugins.nvim-treesitter.builtGrammars.${grammar}) grammars;
in
{
  options.my.programs.nvim.treesitter = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Treesitter grammars";
    default = [ ];
  };

  config = {
    my.programs.nvim.treesitter = [
      "vim"
      "vimdoc"
      "regex"
      "editorconfig"
    ];

    programs.nixvim.plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        nixGrammars = true;
        gccPackage = null;
        nodejsPackage = null;
        treesitterPackage = null;
        grammarPackages = mkGrammars config.my.programs.nvim.treesitter;
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
