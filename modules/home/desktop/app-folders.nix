{ config, lib, ... }:
let
  cfg = config.desktop;
in
{
  options.desktop = {
    appFolders = lib.mkOption {
      description = "Create app folder";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = lib.genAttrs [ "apps" "categories" ] (
            name:
            lib.mkOption {
              description = "${name} to part of folder";
              type = lib.types.listOf lib.types.str;
              default = [ ];
            }
          );
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    desktop.appFolders = {
      Games.categories = [ "Game" ];
      Office.categories = [ "Office" ];
      System.apps = [
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.Settings.desktop"
      ];
      Terminal.categories = [
        "TerminalEmulator"
        "ConsoleOnly"
      ];
      Viewer.categories = [
        "AudioVideo"
        "Viewer"
      ];
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
            inherit (folder.value) categories apps;
          };
        }) (lib.attrsets.attrsToList cfg.appFolders)
      ))
    ];
  };
}
