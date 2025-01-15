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
  options.programs.nixvim.plugins.treesitter.grammars = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Treesitter grammars";
    default = [ ];
  };

  config.programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixvimInjections = true;
      nixGrammars = true;
      gccPackage = null;
      nodejsPackage = null;
      treesitterPackage = null;
      grammars = [
        "vim"
        "vimdoc"
        "regex"
        "editorconfig"
      ];
      grammarPackages = mkGrammars config.programs.nixvim.plugins.treesitter.grammars;
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
}
