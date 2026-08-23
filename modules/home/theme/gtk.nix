{ config, lib, ... }:
let
  cfg = config.theme.gtk;
in
{
  options.theme.gtk = {
    enable = lib.mkEnableOption "GTK";
  };

  config = lib.mkIf cfg.enable {
    dconf = {
      enable = true;

      settings."org/gnome/desktop/interface" = {
        color-scheme = if config.theme.light then "default" else "prefer-dark";
      };
    };
  };
}
