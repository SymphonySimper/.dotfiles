{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf my.gui.desktop.enable {
    programs.sway.enable = true;

    security = {
      polkit.enable = true;
      pam.services = {
        sway.enableGnomeKeyring = true;
        # Enable swaylock
        swaylock = { };
      };
    };

    services = {
      gnome.gnome-keyring.enable = true;
      udisks2.enable = true;
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = [
        (pkgs.writeShellScriptBin "myreload" # sh
          ''
            sudo systemctl restart kanata-keyboard.service        
            sudo systemctl restart NetworkManager
            ${lib.my.mkNotification { title = "Restarted network manager and Kanata"; }}
          ''
        )
      ];
    };

    my.programs.tty."1" = {
      skipUsername = true;
      launch = {
        command = "sway";
        dbus = false;
      };
    };
  };
}
