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
      super = "SUPER";
      ctrl = "CTRL";
      alt = "ALT";
      shift = "SHIFT";
    };

    direction = {
      left = "h";
      down = "j";
      up = "k";
      right = "l";
    };
  };

  workspaces = builtins.genList (x: x + 1) 10;
in
{
  imports = [
    ./scripts
    ./services
    ./utils
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

              command = lib.mkOption {
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
                    # static
                    "float"
                    "size"
                    "center"
                    "tile"
                    "fullscreen"
                    "maximize"
                    "pin"

                    # dynamic
                    "idleinhibit"
                  ];

                  statesSubmodule = lib.types.submodule {
                    options = {
                      name = lib.mkOption {
                        type = states;
                        description = "Name of state";
                      };

                      opts = lib.mkOption {
                        type = lib.types.nullOr (
                          lib.types.oneOf [
                            lib.types.str
                            (lib.types.listOf lib.types.str)
                          ]
                        );
                        description = "Additional options for state";
                        default = null;
                      };
                    };
                  };
                in
                lib.types.nullOr (
                  lib.types.oneOf [
                    states
                    statesSubmodule
                    (lib.types.listOf (
                      lib.types.oneOf [
                        states
                        statesSubmodule
                      ]
                    ))
                  ]
                );
              description = "State of the window";
              default = null;
            };

            workspace = lib.mkOption {
              type = lib.types.nullOr (lib.types.enum workspaces);
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
              type = lib.types.oneOf [
                lib.types.str
                (lib.types.listOf lib.types.str)
              ];
              description = "Window identifier";
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
          autostart = [
            {
              # set wallpaper
              name = "myswaybg";
              command = lib.getExe (
                pkgs.writeShellScriptBin "myswaybg" ''
                  exec ${lib.getExe' pkgs.swaybg "swaybg"} -c "${my.theme.color.crust}" -m solid_color
                ''
              );
            }
          ];

          windows = [
            {
              id = "xdg-desktop-portal-gtk";
              state = [
                "float"
                "center"
              ];
            }

            {
              id = "jetbrains-studio";
              workspace = 4;
            }
          ];
        };

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
            package = null;
            portalPackage = null;
            xwayland.enable = false;
            systemd = {
              enable = false;
              variables = [ "--all" ];
            };

            settings = {
              monitorv2 = {
                output = my.gui.display.name;
                mode = (
                  builtins.concatStringsSep "" [
                    my.gui.display.string.width
                    "x"
                    my.gui.display.string.height
                    "@"
                    my.gui.display.string.refreshRate
                  ]
                );
                position = "0x0";
                scale = my.gui.display.string.scale;
              };

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
                layout = "master";

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

              master = {
                mfact = 0.60;
                inherit_fullscreen = true;
              };

              misc = {
                force_default_wallpaper = 0;
                disable_splash_rendering = true;
                disable_hyprland_logo = true;
                focus_on_activate = false;
                vrr = if my.gui.display.vrr then 1 else 0; # Adaptive sync
              };

              input = {
                kb_layout = "us";
                follow_mouse = 0;
                sensitivity = 0;
                accel_profile = "flat";

                touchpad = {
                  disable_while_typing = true;
                  natural_scroll = false;
                  tap-to-click = true;
                };
              };

              gesture = [ "3, horizontal, workspace" ];

              binds = {
                workspace_back_and_forth = true;
                movefocus_cycles_fullscreen = true;
              };

              bind = lib.lists.flatten [
                "${keys.mod.super}, Q, killactive"
                "${keys.mod.super} ${keys.mod.shift}, E, exec, uwsm stop"
                "${keys.mod.super}, f, fullscreen"
                "${keys.mod.super} ${keys.mod.shift}, F, togglefloating"
                "${keys.mod.super}, space, cyclenext"

                (builtins.map (
                  bind:
                  let
                    prefix = if bind.mods == null then "," else "${builtins.concatStringsSep " " bind.mods},";
                  in
                  "${prefix} ${bind.key}, exec, ${if bind.uwsm then cfg.uwsm else ""} ${bind.command}"
                ) cfg.keybinds)

                (builtins.concatMap (
                  num:
                  let
                    index = builtins.toString num;
                    key = builtins.toString (if num == 10 then 0 else num);
                  in
                  [
                    # Switch workspaces with mainMod + [0-9]
                    "${keys.mod.super}, ${key}, workspace, ${index}"
                    # Move active window to a workspace with mainMod + shift + [0-9]
                    "${keys.mod.super} ${keys.mod.shift}, ${key}, movetoworkspace, ${index}"
                  ]
                ) workspaces)
              ];

              windowrule = lib.lists.flatten [
                # refer: https://github.com/hyprwm/Hyprland/pull/4704#issuecomment-2304649119
                "noborder, onworkspace:w[tv1] f[-1], floating:0"

                (builtins.concatMap (
                  window:
                  let
                    ids = if builtins.typeOf window.id == "list" then window.id else [ window.id ];
                    states =
                      (if builtins.typeOf window.state == "list" then window.state else [ window.state ])
                      ++ (lib.optionals (window.workspace != null) [ null ]);
                  in
                  builtins.concatMap (
                    id:
                    (builtins.map (
                      state:
                      builtins.concatStringsSep ", " (
                        builtins.filter (r: (builtins.stringLength r) > 0) [
                          (lib.strings.optionalString (state != null) (
                            if builtins.typeOf state == "string" then
                              state
                            else
                              builtins.concatStringsSep " " (
                                [ state.name ]
                                ++ (
                                  let
                                    opts = state.opts;
                                  in
                                  lib.optionals (opts != null) (if builtins.typeOf opts == "list" then opts else [ opts ])
                                )
                              )
                          ))

                          (lib.strings.optionalString (window.workspace != null && state == null) (
                            builtins.concatStringsSep " " [
                              "workspace"
                              (builtins.toString window.workspace)
                              (lib.strings.optionalString window.silent "silent")
                            ]
                          ))

                          "${window.type}:^(${id})$"
                        ]
                      )
                    ) states)
                  ) ids
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
                          (builtins.concatStringsSep " " ([ keys.mod.super ] ++ action.mod))
                          value
                          action.name
                          name
                        ])
                      )
                      {
                        l = keys.direction.left;
                        r = keys.direction.right;
                        u = keys.direction.up;
                        d = keys.direction.down;
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
                      mod = [ keys.mod.shift ];
                    }
                    {
                      name = "movewindow";
                      mod = [ keys.mod.ctrl ];
                    }
                  ]
              );

              bindm = [
                "${keys.mod.super}, mouse:272, movewindow"
                "${keys.mod.super}, mouse:273, resizewindow"
              ];
            };

            ## resize windows
            extraConfig = # conf
              ''
                bind = ${keys.mod.super}, R, submap, resize
                submap = resize

                binde = , ${keys.direction.right}, resizeactive, 10 0
                binde = , ${keys.direction.left}, resizeactive, -10 0
                binde = , ${keys.direction.up}, resizeactive, 0 -10
                binde = , ${keys.direction.down}, resizeactive, 0 10

                bind = , escape, submap, reset
                submap = reset
              '';
          }
        ];
      }
      {
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
                          curr_day=$(date +%u)

                          if [[ " ''${allowed_days[*]} " == *" $curr_day "* ]]; then
                            exec ${entry.command}
                          fi
                        ''
                    )
                  else
                    entry.command;
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
      }
    ]
  );
}
