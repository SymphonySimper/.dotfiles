{ my, lib, ... }:
{
  options.my.programs.wm.enableLogin = lib.mkOption {
    description = "WM Login";
    type = lib.types.bool;
    default = (my.gui.desktop.enable && my.gui.desktop.wm);
  };

  config = lib.mkIf (my.gui.desktop.enable && my.gui.desktop.wm) {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [ ];
    };

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

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    my.user.tty."1" = {
      skipUsername = true;
      launch = {
        command = "sway";
        dbus = false;
      };
    };
  };
}
