{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.desktop;

  keys = {
    mod = "SUPER";
    left = "h";
    down = "j";
    up = "k";
    right = "l";
  };
in
{
  imports = lib.optionals my.gui.desktop.enable [
    ./scripts
    ./services
    ./utils
  ];

  options.my.desktop = {
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

    uwsm = lib.mkOption {
      type = lib.types.str;
      description = "UWSM prefix to launch programs with";
      readOnly = true;
      default = "uwsm-app --";
    };

    keybinds = lib.mkOption {
      description = "Keybinds";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            super = lib.mkOption {
              type = lib.types.bool;
              description = "Include super key in combination";
              default = true;
            };

            mod = lib.mkOption {
              type = lib.types.nullOr (
                lib.types.enum [
                  "CTRL"
                  "SHIFT"
                ]
              );
              description = "Modifier to be used";
              default = null;
            };

            key = lib.mkOption {
              type = lib.types.str;
              description = "Finaly key in the combination";
            };

            cmd = lib.mkOption {
              type = lib.types.str;
              description = "Command to run";
            };

            uwsm = lib.mkEnableOption "Launch with UWSM";
          };
        }
      );
    };

    windows = lib.mkOption {
      description = "Windows";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            state = lib.mkOption {
              # refer: https://wiki.hyprland.org/Configuring/Window-Rules/#static-rules
              type =
                let
                  states = lib.types.enum [
                    "float"
                    "tile"
                    "fullscreen"
                    "maximize"
                    "pin"
                  ];
                in
                lib.types.nullOr (
                  lib.types.oneOf [
                    states
                    (lib.types.listOf states)
                  ]
                );
              description = "State of the window";
              default = null;
            };

            center = lib.mkOption {
              type = lib.types.bool;
              description = "Keep the floating window at ther center";
              default = true;
            };

            workspace = lib.mkOption {
              type = lib.types.nullOr (lib.types.enum (builtins.genList (x: x + 1) 10));
              description = "Workspace where the window should be placed";
              default = null;
            };

            silent = lib.mkEnableOption "Silent";

            type = lib.mkOption {
              type = lib.types.enum [
                "class"
                "title"
              ];
              description = "Type of window indentifier";
              default = "class";
            };

            id = lib.mkOption {
              type = lib.types.str;
              description = "Window identifier";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf my.gui.desktop.enable {
    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    # protal settings
    xdg.configFile."hypr/xdph.conf".text = ''
      screencopy {
          max_fps = 60
          allow_token_by_default = true
      }
    '';

    wayland.windowManager.hyprland = lib.mkMerge [
      {
        enable = true;
        xwayland.enable = true;
        systemd = {
          enable = false;
          variables = [ "--all" ];
        };

        settings = {
          monitor = builtins.concatStringsSep ", " [
            my.gui.display.name
            (builtins.concatStringsSep "" [
              my.gui.display.string.width
              "x"
              my.gui.display.string.height
              "@"
              my.gui.display.string.refreshRate
              "Hz"
            ])
            "auto"
            my.gui.display.string.scale
          ];

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];

          # Look and Feel
          general = {
            gaps_in = 0;
            gaps_out = 0;
            border_size = 1;
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";

            "col.inactive_border" = "$overlay0";
            "col.active_border" = "$accent";
          };

          decoration = {
            rounding = 0;

            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow.enabled = false;
            blur.enabled = true;
          };
          animations.enabled = false;

          dwindle = {
            pseudotile = true;
            preserve_split = true;
            force_split = 2;
          };

          misc = {
            force_default_wallpaper = 0;
            disable_splash_rendering = true;
            disable_hyprland_logo = true;
            focus_on_activate = false;
            # Disable Adaptive sync
            vrr = 0;
          };

          input = {
            kb_layout = "us";
            follow_mouse = 0;
            sensitivity = 0;
            accel_profile = "flat";

            touchpad = {
              natural_scroll = false;
              tap-to-click = true;
            };
          };

          gestures = {
            workspace_swipe = false;
          };

          bind = lib.lists.flatten [
            "${keys.mod}, Q, killactive"
            "${keys.mod} SHIFT, E, exec, uwsm stop"
            "${keys.mod}, V, togglefloating"
            "${keys.mod} SHIFT, F, fullscreen"
            "${keys.mod}, space, cyclenext"

            (
              let
                playerctl = lib.getExe pkgs.playerctl;
              in
              builtins.concatMap
                (action: builtins.map (key: ",XF86Audio${key}, exec, ${playerctl} ${action.name}") action.value)
                (
                  lib.attrsets.attrsToList {
                    play-pause = [
                      "Play"
                      "Pause"
                    ];
                    next = [ "Next" ];
                    previous = [ "Prev" ];
                  }
                )
            )

            (builtins.map (
              bind:
              let
                modKey = if bind.super then "${keys.mod}" else "";
                action = if bind.mod != null then bind.mod else "";

                prefix = if modKey == "" && action == "" then "," else "${modKey} ${action},";
              in
              "${prefix} ${bind.key}, exec, ${if bind.uwsm then cfg.uwsm else ""} ${bind.cmd}"
            ) cfg.keybinds)

            (builtins.concatMap (
              num:
              let
                workspaceNum = builtins.toString (if num == 0 then 10 else num);
                numStr = builtins.toString num;
              in
              [
                # Switch workspaces with mainMod + [0-9]
                "${keys.mod}, ${numStr}, workspace, ${workspaceNum}"
                # Move active window to a workspace with mainMod + SHIFT + [0-9]
                "${keys.mod} SHIFT, ${numStr}, movetoworkspace, ${workspaceNum}"
              ]
            ) (lib.lists.range 0 9))
          ];

          windowrule = lib.lists.flatten [
            # refer: https://github.com/hyprwm/Hyprland/pull/4704#issuecomment-2304649119
            "noborder, onworkspace:w[tv1] f[-1], floating:0"

            (builtins.concatMap (
              window:
              let
                states = if builtins.typeOf window.state == "list" then window.state else [ window.state ];
              in
              builtins.map (
                state:
                builtins.concatStringsSep ", " (
                  builtins.filter (r: (builtins.stringLength r) > 0) [
                    (lib.strings.optionalString (state != null) state)
                    (lib.strings.optionalString (state == "float" && window.center) "center") # center floating window
                    (lib.strings.optionalString (
                      window.workspace != null
                    ) "workspace ${builtins.toString window.workspace} ${if window.silent then "silent" else ""}")
                    "${window.type}:^(${window.id})$"
                  ]
                )
              ) states
            ) cfg.windows)
          ];
        };
      }

      {
        # window manipulation binds
        settings = {
          bind = lib.lists.flatten (
            builtins.map
              (
                action:
                (lib.attrsets.mapAttrsToList
                  (
                    name: value:
                    (builtins.concatStringsSep ", " [
                      (builtins.concatStringsSep " " ([ keys.mod ] ++ action.mod))
                      value
                      action.name
                      name
                    ])
                  )
                  {
                    l = keys.left;
                    r = keys.right;
                    u = keys.up;
                    d = keys.down;
                  }
                )
              )
              [
                {
                  name = "movefocus";
                  mod = [ ];
                }
                {
                  name = "swapwindow";
                  mod = [ "SHIFT" ];
                }
                {
                  name = "movewindow";
                  mod = [ "CTRL" ];
                }
              ]
          );

          bindm = [
            "${keys.mod}, mouse:272, movewindow"
            "${keys.mod}, mouse:273, resizewindow"
          ];
        };

        ## resize windows
        extraConfig = # conf
          ''
            bind = ${keys.mod}, R, submap, resize
            submap = resize

            binde = , ${keys.right}, resizeactive, 10 0
            binde = , ${keys.left}, resizeactive, -10 0
            binde = , ${keys.up}, resizeactive, 0 -10
            binde = , ${keys.down}, resizeactive, 0 10

            bind = , escape, submap, reset
            submap = reset
          '';
      }
    ];

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

    my.desktop = {
      autostart = [
        {
          # set wallpaper
          name = "myswaybg";
          cmd = lib.getExe (
            pkgs.writeShellScriptBin "myswaybg" ''
              exec ${lib.getExe' pkgs.swaybg "swaybg"} -c "${my.theme.color.crust}" -m solid_color
            ''
          );
        }
      ];

      mime."org.gnome.Loupe" = [
        "image/jpeg"
        "image/png"
      ];

      keybinds = [
        {
          mod = "SHIFT";
          key = "F5";
          cmd = "myreload";
        }
      ];

      windows = [
        {
          id = "xdg-desktop-portal-gtk";
          state = "float";
        }

        # waydroid
        {
          id = "Waydroid";
          workspace = 7;
        }
        {
          id = "waydroid.com.mojang.minecraftpe";
          state = "fullscreen";
        }

        # steam
        {
          id = "steam";
          silent = true;
          workspace = 6;
        }
        {
          id = "steam_app_.*";
          workspace = 7;
        }
        {
          id = "gamescope";
          workspace = 7;
          state = "fullscreen";
        }
      ];
    };
  };
}
