{ pkgs, config, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = [
          "gtk"
          (if config.my.gui.de.name == "hyprland" then "hyprland" else "wlr")
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      (
        if config.my.gui.de.name == "hyprland" then
          pkgs.xdg-desktop-portal-hyprland
        else
          pkgs.xdg-desktop-portal-wlr
      )
    ];
  };
}
