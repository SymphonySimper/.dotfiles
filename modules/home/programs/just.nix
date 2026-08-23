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

    programs.helix.lang.just = {
      formatter = {
        command = lib.getExe package;
        args = [ "--dump" ];
      };
    };
  };
}
