{ den, lib, ... }: {
  den.default.includes = [ den.aspects.options.desktop.gnome.wallpaper ];

  den.aspects.options.desktop.gnome.wallpaper = {
    homeManager.options.desktop.gnome.wallpaper = lib.mkOption {
      description = "Wallpaper store path";
      type = lib.types.nullOr lib.types.pathInStore;
      default = null;
    };
  };

  den.aspects.desktop.gnome = {
    homeManager =
      { config, ... }:
      let
        cfg = config.desktop.gnome;
        wallpaper = if cfg.wallpaper == null then null else "file://${cfg.wallpaper}";
      in
      {
        config = lib.mkIf (wallpaper != null) {
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
      };
  };
}
