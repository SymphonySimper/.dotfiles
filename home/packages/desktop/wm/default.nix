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
    pavucontrol
  ];

  targets.genericLinux.enable = false;
  services.gnome-keyring.enable = true;

  xdg = {
    portal = {
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

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = "org.gnome.Loupe.desktop";
      };
    };
  };
}
