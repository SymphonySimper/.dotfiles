{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.desktop.enable = lib.mkEnableOption "Desktop" // {
    default = my.gui.desktop.enable;
  };

  config = lib.mkIf config.my.programs.desktop.enable (
    lib.mkMerge [
      {
        services = {
          desktopManager.gnome.enable = true;

          displayManager.gdm = {
            enable = true;
            wayland = true;
          };
        };

        environment = {
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
      }
      {
        environment.sessionVariables.NIXOS_OZONE_WL = "1";

        my = {
          boot.enable = true;

          hardware = {
            audio = {
              enable = true;
              programs.enable = lib.mkDefault true;
            };

            powerManagement.enable = true;
          };

          programs = {
            browser.enable = true;
          };
        };
      }
    ]
  );
}
