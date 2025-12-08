{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.desktop;

  keys = {
    mod = {
      super = "<Super>";
      ctrl = "<Control>";
      alt = "<Alt>";
      shift = "<Shift>";
    };
  };
in
{
  imports = [ ./services ];

  options.my.programs.desktop = {
    enable = lib.mkEnableOption "Desktop";

    autostart = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the desktop entry";
            };

            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to exec";
            };
          };
        }
      );
      description = "Desktop or command entries to autostart on startup";
      default = [ ];
    };

    keybinds = lib.mkOption {
      description = "Keybinds";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            mods = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf (lib.types.enum (builtins.attrNames keys.mod)));
              description = "Modifiers to be use";
              default = null;
            };

            key = lib.mkOption {
              type = lib.types.str;
              description = "Finaly key in the combination";
            };

            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to run";
            };
          };
        }
      );
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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        my.programs.desktop = {
          appfolder = {
            Games.categories = [ "Game" ];
          };
        };

        programs.gnome-shell = {
          enable = true;

          extensions = [
            {
              # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/desktops/gnome/extensions/buildGnomeExtension.nix
              package =
                let
                  pname = "my";
                  uuid = "my@symphonysimper.com";
                in
                pkgs.stdenv.mkDerivation {
                  pname = "gnome-shell-extension-${pname}";
                  uuid = uuid;
                  version = "1";
                  src = ./extension;

                  installPhase = ''
                    mkdir -p $out/share/gnome-shell/extensions/
                    cp -r -T . $out/share/gnome-shell/extensions/${uuid}
                  '';

                  passthru = {
                    extensionPortalSlug = pname;
                    extensionUuid = uuid;
                  };
                };
            }
          ];
        };

        dconf = {
          enable = true;

          settings = lib.mkMerge [
            {
              "org/gnome/mutter" = {
                dynamic-workspaces = true;

                experimental-features = [
                  # "scale-monitor-framebuffer" # fractional scaling
                  # "variable-refresh-rate"
                ];
              };

              # shell
              "org/gnome/shell" = {
                app-picker-layout = [ ]; # resets app order
                favorite-apps = [ ];
              };

              "org/gnome/shell/app-switcher".current-workspace-only = true;

              "org/gnome/desktop/interface" = {
                enable-animations = true;
                enable-hot-corners = false;
                show-battery-percentage = true;
              };

              "org/gnome/desktop/sound" = {
                allow-volume-above-100-percent = true;
              };

              ## wallpaper
              "org/gnome/desktop/background" = {
                picture-uri = my.theme.wallpaper;
                picture-uri-dark = my.theme.wallpaper;
              };

              "org/gnome/desktop/screensaver" = {
                picture-uri = my.theme.wallpaper;
              };

              "org/gnome/settings-daemon/plugins/color" = {
                night-light-enabled = false;
                night-light-schedule-automatic = false;
                night-light-temperature = lib.hm.gvariant.mkUint32 3700;
              };

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

            (
              let
                customKeybinds = (
                  builtins.listToAttrs (
                    lib.lists.imap0 (i: bind: {
                      name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${builtins.toString i}";
                      value = {
                        name = if builtins.hasAttr "name" bind then bind.name else bind.command;
                        binding = builtins.concatStringsSep "" (
                          (lib.lists.optionals (bind.mods != null) (builtins.map (mod: keys.mod.${mod}) bind.mods))
                          ++ [ bind.key ]
                        );
                        command = bind.command;
                      };
                    }) cfg.keybinds
                  )
                );
              in
              lib.mkMerge [
                # Keybinds
                {
                  "org/gnome/mutter".overlay-key = "Super_L";

                  "org/gnome/desktop/input-sources" = {
                    xkb-options = [
                      "terminate:ctrl_alt_bksp" # default for xkb-options
                      "lv3:rwin_switch" # alternate characters key: setting it to right super to free right alt
                      "ctrl:nocaps" # caps lock as ctrl
                    ];
                  };

                  "org/gnome/desktop/wm/keybindings" = {
                    minimize = [ ];
                    close = [ "<Super>q" ]; # close app
                    toggle-maximized = [ "<Super>f" ];
                    toggle-fullscreen = [ "<Super><Shift>f" ];

                    switch-windows = [ "<Alt>Tab" ];
                    switch-windows-backward = [ "<Alt><Shift>Tab" ];
                    ## disable switch-applications binding as sometimes it just takes over <Alt>Tab
                    switch-applications = [ ];
                    switch-applications-backward = [ ];

                    switch-to-workspace-left = [ "<Super>j" ];
                    switch-to-workspace-right = [ "<Super>k" ];
                    move-to-workspace-left = [ "<Super><Shift>j" ];
                    move-to-workspace-right = [ "<Super><Shift>k" ];

                    begin-move = [ "<Super>m" ];
                    begin-resize = [ "<Super>r" ];

                    switch-input-source = [ ];
                    switch-input-source-backward = [ ];
                  };

                  "org/gnome/shell/keybindings" = {
                    screenshot = [ "<Super>F11" ];
                    show-screenshot-ui = [ "<Super><Shift>F11" ];
                    show-screen-recording-ui = [ "<Super><Control>F11" ];
                  };

                  "org/gnome/settings-daemon/plugins/media-keys" = {
                    mic-mute = [ "F8" ];
                    play = [ "F7" ];
                    volume-down = [ "<Super>F2" ];
                    volume-mute = [ "<Super><Shift>F2" ];
                    volume-up = [ "<Super>F3" ];

                    screensaver = [ "<Super>Escape" ];
                    logout = [ "<Super><Control>Escape" ];
                    shutdown = [ "<Super><Alt>Escape" ];
                    reboot = [ "<Super><Alt><Control>Escape" ];

                    home = [ "<Super><Shift>e" ];
                    www = [ "<Super>b" ]; # launch browser

                    custom-keybindings = builtins.map (name: "/${name}/") (builtins.attrNames customKeybinds);
                  };

                  "org/gnome/mutter/wayland/keybindings" = {
                    restore-shortcuts = [ ];
                  };
                }

                ## Custom Keybinds
                customKeybinds
              ]
            )
          ];
        };
      }

      {
        xdg = {
          autostart = lib.mkIf (builtins.length cfg.autostart > 0) {
            enable = true;
            readOnly = true;

            entries = builtins.map (
              entry:
              let
                desktopEntry = pkgs.makeDesktopItem {
                  name = entry.name;
                  exec = entry.command;
                  desktopName = entry.name;
                };
              in
              "${desktopEntry}/share/applications/${entry.name}.desktop"
            ) cfg.autostart;
          };
        };
      }
    ]
  );
}
