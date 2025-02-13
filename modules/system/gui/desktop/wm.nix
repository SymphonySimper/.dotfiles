{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.wm.enableLogin = lib.mkOption {
    description = "WM Login";
    type = lib.types.bool;
    default = (my.gui.desktop.enable && my.gui.desktop.wm);
  };

  config = lib.mkIf (my.gui.desktop.enable && my.gui.desktop.wm) {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    security = {
      polkit.enable = true;
      pam.services = {
        hyprland.enableGnomeKeyring = true;
        # Enable hyprlock
        hyprlock = { };
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
        command = "${lib.getExe config.programs.uwsm.package} start -S -F /run/current-system/sw/bin/Hyprland";
        dbus = false;
      };
    };
  };
}
