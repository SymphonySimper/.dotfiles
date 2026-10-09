{ config, lib, ... }:
let
  cfg = config.programs.nixvim.plugins.treesitter;
in
{
  options.programs.nixvim.plugins.treesitter = {
    grammars = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Tree-sitters to be added to runtime";
      default = [ ];
    };
  };

  config = {
    programs.nixvim.plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;

      grammarPackages = lib.lists.unique (
        map (grammar: cfg.package.builtGrammars.${grammar}) cfg.grammars
      );
    };
  };
}
