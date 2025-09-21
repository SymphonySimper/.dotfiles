{
  my,
  lib,
  pkgs,
  ...
}:
let
  gtkExtraSettings = {
    gtk-application-prefer-dark-theme = my.theme.dark;
  };
in
{
  config = lib.mkIf my.gui.enable (
    lib.mkMerge [
      {
        fonts.fontconfig.enable = true;

        home.packages = with pkgs; [
          (google-fonts.override { fonts = [ "Poppins" ]; })
          font-awesome
          nerd-fonts.jetbrains-mono
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-emoji
        ];
      }

      {
        catppuccin = {
          gtk.icon.enable = false;
          kvantum.enable = false; # qt
        };

        home.pointerCursor = {
          gtk.enable = true;
          # x11.enable = true;
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 16;
        };

        gtk = {
          enable = true;

          theme = {
            name = my.theme.gtk;
            package = pkgs.gnome-themes-extra;
          };

          iconTheme = {
            package = pkgs.adwaita-icon-theme;
            name = "Adwaita";
          };

          gtk3.extraConfig = gtkExtraSettings;
          gtk4.extraConfig = gtkExtraSettings; # required for non libadwaita applications

          # font = {
          #   name = "Sans";
          #   size = 11;
          # };
        };

        qt = {
          enable = true;
          platformTheme.name = "adwaita";
          style.name = lib.toLower my.theme.gtk;
        };

        dconf = {
          enable = true;

          settings."org/gnome/desktop/interface" = {
            color-scheme = if my.theme.dark then "prefer-dark" else "default";
            cursor-theme = "Adwaita";
            gtk-theme = my.theme.gtk;
            icon-theme = "Adwaita";
            toolkit-accessibility = false;
          };
        };
      }
    ]
  );
}
