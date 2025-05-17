{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.desktop.enable = lib.mkEnableOption "Desktop";

  config = lib.mkIf config.my.programs.desktop.enable {
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

        tty."1" = {
          skipUsername = true;
          launch =
            let
              uwsm = "${lib.getExe config.programs.uwsm.package}";
            in
            {
              command = # sh
                ''
                  if ${uwsm} check may-start; then
                      exec ${uwsm} start ${config.my.user.bin}/Hyprland
                  fi
                '';
              dbus = false;
            };
        };
      };
    };
  };
}
