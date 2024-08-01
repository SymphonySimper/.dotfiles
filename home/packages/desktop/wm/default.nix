{ pkgs, ... }:
{
  imports = [
    # ./hyprland.nix
    # ./river.nix
    ./sway.nix
    ./utils/default.nix
    ./scripts/default.nix
  ];

  home.packages = with pkgs; [
    foliate
    loupe
    nautilus
  ];

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
          "wlr"
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };
}
