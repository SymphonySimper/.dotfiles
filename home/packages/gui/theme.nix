{
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  gtkExtraSettings = ''gtk-application-prefer-dark-theme=${
    if userSettings.theme.dark then "1" else "0"
  }'';
in
{

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (google-fonts.override { fonts = [ "Poppins" ]; })
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

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
      name = userSettings.theme.gtk;
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
      name = lib.toLower userSettings.theme.gtk;
    };
  };
}
