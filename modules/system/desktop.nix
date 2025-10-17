{ config, lib, ... }:
{
  options.my.programs.desktop.enable = lib.mkEnableOption "Desktop";

  config = lib.mkIf config.my.programs.desktop.enable (
    lib.mkMerge [
      {
        programs.hyprland = {
          enable = true;
          withUWSM = true;
          xwayland.enable = false;
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
          udisks2.enable = true;
        };

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

      {
        # uwsm module enables display manager.
        # which then overrides tty1 (https://github.com/NixOS/nixpkgs/pull/429845)
        services.displayManager.enable = lib.mkForce false;

        my.programs.tty."1" = {
          skipUsername = true;
          launch = {
            command = # sh
              ''
                if uwsm check may-start; then
                    exec uwsm start /run/current-system/sw/bin/Hyprland
                fi
              '';
            dbus = false;
          };
        };
      }
    ]
  );
}
