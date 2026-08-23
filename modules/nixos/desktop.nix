{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.desktop;
in
{
  options.desktop = {
    enable = lib.mkEnableOption "Desktop";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      gnome.excludePackages = with pkgs; [
        baobab # disk usage analyzer
        epiphany # browser
        geary # email
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-system-monitor
        gnome-text-editor
        gnome-tour
        gnome-weather
        simple-scan
        sushi # nautilus preview
        yelp
      ];
    };
  };
}
