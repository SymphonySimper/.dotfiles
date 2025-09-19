{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.desktop.enable = lib.mkEnableOption "Desktop";

  config = lib.mkIf config.my.programs.desktop.enable {
    services = {
      desktopManager.gnome.enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      gnome.excludePackages = with pkgs; [
        epiphany
        geary
        gnome-characters
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-maps
        gnome-music
        gnome-shell-extensions
        gnome-text-editor
        gnome-tour
        gnome-weather
        simple-scan
        yelp
      ];
    };

    my = {
      boot.enable = true;

      hardware = {
        audio = {
          enable = true;
          programs.enable = lib.mkDefault true;
        };

        keyboard.enable = true;
        powerManagement.enable = true;
      };

      programs = {
        browser.enable = true;
      };
    };
  };
}
