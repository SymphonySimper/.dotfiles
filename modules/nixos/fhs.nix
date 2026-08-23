{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.fhs;
in
{
  options.fhs = {
    enable = lib.mkEnableOption "FHS" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;

      libraries = [
        pkgs.stdenv.cc.cc
        pkgs.zlib
      ];
    };
  };
}
