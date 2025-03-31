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
  };
}
