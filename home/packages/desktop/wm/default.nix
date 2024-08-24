{ pkgs, userSettings, ... }:
{
  imports = [
    ./hyprland.nix
    ./scripts/default.nix
    ./sway.nix
    ./utils/default.nix
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

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = "org.gnome.Loupe.desktop";
      };
    };
  };
}
