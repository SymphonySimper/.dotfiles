{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.desktop;

  workspaces = 5;
  workspacesList = builtins.genList (w: builtins.toString (w + 1)) workspaces;
in
{
  imports = [
    ./services
  ];

  options.my.programs.desktop = {
    enable = lib.mkEnableOption "Desktop";

    autostart = lib.mkOption {
      type = lib.types.listOf (
        lib.types.oneOf [
          lib.types.str
          (lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Name of the desktop entry";
              };

              cmd = lib.mkOption {
                type = lib.types.str;
                description = "Command to exec";
              };

              days = lib.mkOption {
                # 1: monday
                # 7: sunday
                type = lib.types.nullOr (lib.types.listOf (lib.types.ints.between 1 7));
                description = "Autostart only on these days";
                default = null;
              };
            };
          })
        ]
      );
      description = "Desktop or command entries to autostart on startup";
      default = [ ];
    };

    mime = lib.mkOption {
      description = "Mimeapps";
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = { };
    };

    keybinds = lib.mkOption {
      description = "Keybinds";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            key = lib.mkOption {
              type = lib.types.str;
              description = "Key combination";
            };

            cmd = lib.mkOption {
              type = lib.types.str;
              description = "Command to run";
            };
          };
        }
      );
    };

    automove = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            workspace = lib.mkOption {
              type = lib.types.ints.between 1 workspaces;
              description = "Workspace to move the window to";
            };

            name = lib.mkOption {
              type = lib.types.str;
              description = "Desktop file name";
              example = "alacritty.desktop";
            };
          };
        }
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
  };

  config = lib.mkIf cfg.enable {
    my.programs.desktop = {
      appfolder = {
        CLI.categories = [ "ConsoleOnly" ];
        Games.categories = [ "Game" ];
        Office.categories = [ "Office" ];
        Utilities.categories = [ "X-GNOME-Utilities" ];
      };

      mime."org.gnome.Loupe" = [
        "image/jpeg"
        "image/png"
      ];
    };

    # avatar
    home.file.".face".source = ../../flake/assets/images/avatar.png; # it has to be a png

    programs.gnome-shell = {
      enable = true;
      extensions = [
        { package = pkgs.gnomeExtensions.caffeine; }
        { package = pkgs.gnomeExtensions.auto-move-windows; }
      ];
    };

    dconf = {
      enable = true;

      settings = lib.mkMerge [
        {
          # shell
          "org/gnome/shell" = {
            app-picker-layout = [ ]; # resets app order
            favorite-apps = [ ];
          };

          "org/gnome/desktop/interface" = {
            enable-animations = true;
            show-battery-percentage = true;
          };

          ## wallpaper
          "org/gnome/desktop/background" = {
            picture-uri = my.theme.wallpaper;
            picture-uri-dark = my.theme.wallpaper;
          };

          "org/gnome/desktop/screensaver" = {
            picture-uri = my.theme.wallpaper;
          };

          # "org/gnome/settings-daemon/plugins/color" = {
          #   night-light-enabled = true;
          #   night-light-schedule-automatic = false;
          #   night-light-temperature = lib.hm.gvariant.mkUint32 3700;
          # };

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

          # applications
          "org/gnome/nautilus/preferences" = {
            click-policy = "single";
            default-folder-viewer = "list-view";
            migrated-gtk-settings = true;
            search-filter-time-type = "last_modified";
            search-view = "list-view";
          };

          # privacy
          "org/gnome/desktop/privacy" = {
            remove-old-temp-files = true;
            remove-old-trash-files = true;
          };

          # extensions
          "org/gnome/shell/extensions/caffeine" = {
            indicator-position-max = 1;
            enable-fullscreen = false;
            show-indicator = "only-active";
            show-notifications = false;
            toggle-shortcut = [ "<Super>F10" ];
          };

          "org/gnome/shell/extensions/auto-move-windows".application-list = builtins.map (
            entry: "${entry.name}:${builtins.toString entry.workspace}"
          ) cfg.automove;
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

        (
          let
            customKeybinds = (
              builtins.listToAttrs (
                lib.lists.imap0 (i: bind: {
                  name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${builtins.toString i}";
                  value = {
                    name = if builtins.hasAttr "name" bind then bind.name else bind.cmd;
                    binding = bind.key;
                    command = bind.cmd;
                  };
                }) cfg.keybinds
              )
            );
          in
          lib.mkMerge [
            # Keybinds
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

            ## Custom Keybinds
            customKeybinds
          ]
        )
      ];
    };

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

      autostart = lib.mkIf (builtins.length cfg.autostart > 0) {
        enable = true;
        readOnly = true;

        entries = builtins.map (
          entry:
          let
            suffix = ".desktop";

            isString = (builtins.typeOf entry) == "string";
            name = if isString then entry else entry.name;
            exec =
              if isString then
                entry
              else if entry.days != null then
                lib.getExe (
                  pkgs.writeShellScriptBin "${name}-day-launcher" # sh
                    ''
                      ${lib.strings.toShellVar "allowed_days" entry.days}
                      curr_day=$(${lib.getExe' pkgs.coreutils "date"} +%u)

                      if [[ " ''${allowed_days[*]} " == *" $curr_day "* ]]; then
                        exec ${entry.cmd}
                      fi
                    ''
                )
              else
                entry.cmd;
          in
          if isString && (lib.strings.hasSuffix suffix entry) then
            entry
          else
            let
              desktopEntry = pkgs.makeDesktopItem {
                inherit name exec;
                desktopName = name;
              };
            in
            "${desktopEntry}/share/applications/${name}${suffix}"
        ) cfg.autostart;
      };
    };
  };
}
