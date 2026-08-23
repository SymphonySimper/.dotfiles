{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.desktop;
in
{
  options.desktop = {
    extensions.enable = lib.mkEnableOption "Extensions" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gnome-shell = {
      enable = true;

      extensions = map (pkg: { package = pkg; }) (
        builtins.attrValues inputs.gnome-shell-extensions.packages.${pkgs.stdenv.hostPlatform.system}
      );
    };
  };
}
