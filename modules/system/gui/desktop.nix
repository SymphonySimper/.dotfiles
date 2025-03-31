{
  my,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf my.gui.desktop.enable {
    services.xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      desktopManager.gnome.enable = true;

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      systemPackages = with pkgs; [
        foliate

        (writeShellScriptBin "myreload" # sh
          ''
            sudo systemctl restart kanata-keyboard.service        
            sudo systemctl restart NetworkManager
            ${lib.my.mkNotification { title = "Restarted network manager and Kanata"; }}
          ''
        )
      ];

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
  };
}
