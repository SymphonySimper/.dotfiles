{
  my,
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
      systemPackages = [ pkgs.dconf-editor ];

      gnome.excludePackages = with pkgs; [
        decibels
        epiphany
        geary
        gnome-characters
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-font-viewer
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

    # avatar
    # refer: https://wiki.nixos.org/wiki/GNOME#Change_Profile_Photo_for_Login_and_Lockscreen_-_Declarative
    system.activationScripts.script.text =
      # sh
      ''
        avatar="${my.dir.home}/.face"
        if [ ! -f "$avatar" ]; then
          echo "$avatar not found!"
          exit
        fi

        dir_base="/var/lib/AccountsService"
        dir_icons="''${dir_base}/icons"
        dir_users="''${dir_base}/users"
        icons="''${dir_icons}/${my.name}"
        users="''${dir_users}/${my.name}"

        mkdir -p "$dir_icons"
        mkdir -p "$dir_users"

        cp "$avatar" "$icons"
        echo -e "[User]\nIcon=$icons\n" > "$users"

        chown root:root "$users"
        chmod 0600 "$users"

        chown root:root "$icons"
        chmod 0444 "$icons"
      '';

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
