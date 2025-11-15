{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.desktop.enable = lib.mkEnableOption "Desktop";

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
            epiphany # browser
            geary # email
            gnome-connections
            gnome-console
            gnome-contacts
            gnome-font-viewer
            gnome-maps
            gnome-music
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

            keyboard.enable = true;
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
