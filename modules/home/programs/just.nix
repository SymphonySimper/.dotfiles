{
  config,
  pkgs,
  lib,
  ...
}:
let
  package = pkgs.just;
in
{
  # NOTE: programs.just is marked as removed by home-manager. So it cannot be used.
  options.programs.justfile = {
    enable = lib.mkEnableOption "Just" // {
      default = true;
    };
  };

  config = lib.mkIf config.programs.justfile.enable {
    home.packages = [ package ];

    programs.nixvim = {
      plugins.conform-nvim.formatters.just = [ "just" ];
      plugins.treesitter.grammars = [ "just" ];
    };
  };
}
