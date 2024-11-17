{
  lib,
  pkgs,
  my,
  ...
}:
let
  gtkExtraSettings = ''gtk-application-prefer-dark-theme=${if my.theme.dark then "1" else "0"}'';
in
{
  config = lib.mkIf my.gui.enable {
    home.pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 16;
    };

    gtk = {
      enable = true;
      catppuccin.enable = false;
      theme = {
        name = my.theme.gtk;
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      gtk3.extraConfig.settings = gtkExtraSettings;

      gtk4.extraConfig.settings = gtkExtraSettings;

      # font = {
      #   name = "Sans";
      #   size = 11;
      # };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style = {
        catppuccin.enable = false;
        name = lib.toLower my.theme.gtk;
      };
    };
  };
}
