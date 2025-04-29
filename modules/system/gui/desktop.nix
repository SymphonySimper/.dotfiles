{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf my.gui.desktop.enable {
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

    services.udisks2.enable = true;

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      systemPackages = [
        (pkgs.writeShellScriptBin "myreload" # sh
          ''
            sudo systemctl restart NetworkManager
            ${lib.my.mkNotification {
              tag = "myreload";
              title = "Restarted network manager";
            }}
          ''
        )
      ];
    };

    my.programs.tty."1" = {
      skipUsername = true;
      launch =
        let
          uwsm = "${lib.getExe config.programs.uwsm.package}";
        in
        {
          command = # sh
            ''
              if ${uwsm} check may-start; then
                  exec ${uwsm} start /run/current-system/sw/bin/Hyprland
              fi
            '';
          dbus = false;
        };
    };
  };
}
