{ pkgs, userSettings, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = [
          "gtk"
          (if userSettings.desktop.name == "hyprland" then "hyprland" else "wlr")
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      (
        if userSettings.desktop.name == "hyprland" then
          pkgs.xdg-desktop-portal-hyprland
        else
          pkgs.xdg-desktop-portal-wlr
      )
    ];
  };
}
