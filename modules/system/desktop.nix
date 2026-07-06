{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.desktop.enable = lib.mkEnableOption "Enable Desktop";

  config = lib.mkIf config.my.desktop.enable {
    my = {
      boot.enable = true;
      fonts.enable = true;

      hardware = {
        audio.enable = true;
        powerManagement.enable = true;
      };

      programs = {
        browser.enable = true;
      };
    };

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
