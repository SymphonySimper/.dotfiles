{ config, lib, ... }:
let
  cfg = config.desktop;
in
{
  options.desktop = {
    appFolders = lib.mkOption {
      description = "Create app folder";
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    desktop.appFolders = {
      Games = [ "Game" ];
    };

    dconf.settings = lib.mkMerge [
      {
        "org/gnome/desktop/app-folders".folder-children = builtins.attrNames cfg.appFolders;
      }

      (builtins.listToAttrs (
        map (folder: {
          name = "org/gnome/desktop/app-folders/folders/${folder.name}";
          value = {
            name = folder.name;
            categories = folder.value;
          };
        }) (lib.attrsets.attrsToList cfg.appFolders)
      ))
    ];
  };
}
