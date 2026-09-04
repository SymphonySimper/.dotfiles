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
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;


    environment.gnome.excludePackages = with pkgs; [
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
}
