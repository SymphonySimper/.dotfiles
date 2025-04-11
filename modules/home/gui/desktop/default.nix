{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.desktop;
  workspaces = 4;
  workspacesList = builtins.genList (w: builtins.toString (w + 1)) workspaces;

  keybinds = [
    {
      key = "<Shift><Super>F5";
      cmd = "myreload";
    }
  ];

  customKeybinds = builtins.listToAttrs (
    lib.lists.imap0 (i: bind: {
      name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${builtins.toString i}";
      value = {
        name = if builtins.hasAttr "name" bind then bind.name else bind.cmd;
        binding = bind.key;
        command = bind.cmd;
      };
    }) keybinds
  );
in
{
  imports = lib.optionals my.gui.desktop.enable [
    ./services
  ];

  options.my.desktop = {
    autostart = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Desktop entries to autostart on startup";
      default = [ ];
    };

    automove = lib.mkOption {
      type = lib.types.listOf (
        lib.types.listOf (
          lib.types.oneOf [
            lib.types.int
            lib.types.str
          ]
        )
      );
      description = "Auto move window to set workspace";
      default = [ ];
    };

    appfolder = lib.mkOption {
      description = "Create app folder";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            apps = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Desktop Entries to be included in folder";
            };
            categories = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Categories to be included in folder";
            };
          };
        }
      );
    };

    mime = lib.mkOption {
      description = "Mimeapps";
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
    };
  };

  config = lib.mkIf my.gui.desktop.enable {
    my.desktop = {
      automove = [
        [
          "Waydroid.desktop"
          4
        ]
        [
          "steam.desktop"
          4
        ]
      ];

      appfolder = {
        CLI.categories = [ "ConsoleOnly" ];
        Games.categories = [ "Game" ];
        Office.categories = [ "Office" ];
        Utilities.categories = [ "X-GNOME-Utilities" ];
        Waydroid.categories = [ "X-WayDroid-App" ];

        Settings = {
          apps = [
            "org.gnome.Extensions.desktop"
            "solaar.desktop"
          ];
          categories = [ "Settings" ];
        };
      };

      mime."org.gnome.Loupe" = [
        "image/jpeg"
        "image/png"
      ];
    };

    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = caffeine; }
        { package = auto-move-windows; }
        { package = just-perfection; }
      ];
    };

    # avatar
    home.file.".face".source = ../../../flake/assets/images/avatar.png; # it has to be a png

    xdg = {
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = builtins.listToAttrs (
          lib.lists.flatten (
            lib.attrsets.mapAttrsToList (
              name: value:
              (builtins.map (v: {
                name = v;
                value = "${name}.desktop";
              }) value)
            ) cfg.mime
          )
        );
      };
    };

    dconf = {
      enable = true;

      settings = lib.mkMerge [
        {
          # shell
          "org/gnome/shell" = {
            app-picker-layout = [ ]; # resets app order
            favorite-apps = [ ]; # unpin all apps on dash
          };

          "org/gnome/desktop/interface" = {
            color-scheme = if my.theme.dark then "prefer-dark" else "default";
            cursor-size = 16;
            cursor-theme = "Adwaita";
            enable-animations = true;
            gtk-theme = my.theme.gtk;
            icon-theme = "Adwaita";
            show-battery-percentage = true;
            toolkit-accessibility = false;
          };

          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            night-light-schedule-automatic = false;
            night-light-temperature = lib.hm.gvariant.mkUint32 4700;
          };

          ## wallpaper
          "org/gnome/desktop/background" = {
            picture-uri = my.theme.wallpaper;
            picture-uri-dark = my.theme.wallpaper;
          };

          "org/gnome/desktop/screensaver" = {
            picture-uri = my.theme.wallpaper;
          };

          "org/gnome/mutter".experimental-features = [
            "scale-monitor-framebuffer" # fractional scaling
            "variable-refresh-rate"
          ];

          ## mouse
          "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
          "org/gnome/desktop/peripherals/touchpad" = {
            natural-scroll = false;
            two-finger-scrolling-enabled = true;
          };

          ## search
          "org/gnome/desktop/search-providers".disable-external = true;
          "org/freedesktop/tracker/miner/files" = {
            index-recursive-directories = [ ];
            index-single-directories = [ ];
          };

          "org/gnome/desktop/privacy".remove-old-trash-files = true;

          # applications
          "org/gnome/nautilus/preferences" = {
            click-policy = "single";
            default-folder-viewer = "list-view";
            migrated-gtk-settings = true;
            search-filter-time-type = "last_modified";
            search-view = "list-view";
          };

          # extensions
          "org/gnome/shell/extensions/caffeine" = {
            indicator-position-max = 1;
            show-indicator = "only-active";
          };

          "org/gnome/shell/extensions/auto-move-windows".application-list = builtins.map (
            entry: "${builtins.elemAt entry 0}:${builtins.toString (builtins.elemAt entry 1)}"
          ) cfg.automove;

          "org/gnome/shell/extensions/just-perfection" = {
            panel = false;
            panel-in-overview = true;
            support-notifier-type = 0;
          };
        }

        (lib.mkMerge [
          # App folders
          (builtins.listToAttrs (
            builtins.map (folder: {
              name = "org/gnome/desktop/app-folders/folders/${folder.name}";
              value = lib.mkMerge [
                { name = folder.name; }

                (lib.mkIf (builtins.length folder.value.apps > 0) {
                  apps = folder.value.apps;
                })

                (lib.mkIf (builtins.length folder.value.categories > 0) {
                  categories = folder.value.categories;
                })
              ];
            }) (lib.attrsets.attrsToList cfg.appfolder)
          ))

          { "org/gnome/desktop/app-folders".folder-children = builtins.attrNames cfg.appfolder; }
        ])

        {
          # workspace
          "org/gnome/mutter".dynamic-workspaces = false;
          "org/gnome/desktop/wm/preferences".num-workspaces = workspaces;
          "org/gnome/shell/app-switcher".current-workspace-only = true;

          "org/gnome/desktop/wm/keybindings" = builtins.listToAttrs (
            builtins.concatMap (w: [
              {
                name = "move-to-workspace-${w}";
                value = [ "<Shift><Super>${w}" ];
              }
              {
                name = "switch-to-workspace-${w}";
                value = [ "<Super>${w}" ];
              }
            ]) workspacesList
          );

          "org/gnome/shell/keybindings" = builtins.listToAttrs (
            builtins.map (w: {
              name = "switch-to-application-${w}";
              value = [ ];
            }) workspacesList
          );
        }

        (lib.mkMerge [
          # keybinds
          {
            "org/gnome/desktop/wm/keybindings".close = [ "<Super>q" ]; # close app

            "org/gnome/shell/keybindings" = {
              screenshot = [ "<Super>F11" ];
              screenshot-window = [ "<Shift><Control>F11" ];
              show-screenshot-ui = [ "<Shift><Super>F11" ];
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
              home = [ "<Super>e" ];
              mic-mute = [ "F8" ];
              play = [ "F7" ];
              volume-down = [ "<Super>F2" ];
              volume-mute = [ "<Shift><Super>F2" ];
              volume-up = [ "<Super>F3" ];
              custom-keybindings = builtins.map (name: "/${name}/") (builtins.attrNames customKeybinds);
            };
          }

          customKeybinds
        ])
      ];
    };

    xdg.autostart = lib.mkIf (builtins.length cfg.autostart > 0) {
      enable = true;
      entries = cfg.autostart;
    };
  };
}
