{ den, lib, ... }: {
  den.default.includes = [ den.aspects.options.desktop.gnome.app-folders ];

  den.aspects.options.desktop.gnome.app-folders = {
    homeManager.options.desktop.gnome.app-folders = lib.mkOption {
      description = "Create app folder";
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
    };
  };

  den.aspects.desktop.gnome = {
    homeManager =
      { config, lib, ... }:
      let
        cfg = config.desktop.gnome;
      in
      {
        config = {
          desktop.gnome.app-folders = {
            Games = [ "Game" ];
          };

          dconf.settings = {
            "org/gnome/desktop/app-folders".folder-children = builtins.attrNames cfg.app-folders;
          }
          // (builtins.listToAttrs (
            map (folder: {
              name = "org/gnome/desktop/app-folders/folders/${folder.name}";
              value = {
                name = folder.name;
                categories = folder.value;
              };
            }) (lib.attrsets.attrsToList cfg.app-folders)
          ));
        };
      };
  };
}
