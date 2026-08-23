{ config, lib, ... }:
let
  cfg = config.desktop;
  wallpaper = if cfg.wallpaper == null then null else "file://${cfg.wallpaper}";
in
{
  options.desktop = {
    wallpaper = lib.mkOption {
      description = "Wallpaper store path";
      type = lib.types.nullOr lib.types.pathInStore;
      default = null;
    };
  };

  config = lib.mkIf (cfg.enable && wallpaper != null) {
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = wallpaper;
        picture-uri-dark = wallpaper;
      };

      "org/gnome/desktop/screensaver" = {
        picture-uri = wallpaper;
      };
    };
  };
}
