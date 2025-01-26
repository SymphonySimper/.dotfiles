{ my, lib, ... }:
{
  options.my.programs.wm.enableLogin = lib.mkOption {
    description = "WM Login";
    type = lib.types.bool;
    default = (my.gui.desktop.enable && my.gui.desktop.wm);
  };

  config = lib.mkIf (my.gui.desktop.enable && my.gui.desktop.wm) {
    programs.hyprland = {
      enable = true;
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

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    my.programs.tty."1" = {
      skipUsername = true;
      launch = {
        command = "Hyprland";
        dbus = false;
      };
    };
  };
}
