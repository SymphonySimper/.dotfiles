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
        home.packages = with pkgs; [
          noto-fonts-cjk-sans

          (nerd-fonts.jetbrains-mono.overrideAttrs {
            # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/default.nix#L65
            postInstall =
              let
                variants = builtins.concatStringsSep "\\|" [
                  "Regular"
                  "Italic"
                  "Bold.*"
                ];
              in
              # sh
              ''
                find "$dst_truetype" -type f -not -regex ".*JetBrainsMonoNerdFont-\(${variants}\).ttf" -delete
              '';
          })
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
