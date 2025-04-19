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
      type = lib.types.listOf lib.types.str;
      description = "Desktop entries to autostart on startup";
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
            workspace = lib.mkOption {
              type = lib.types.enum (builtins.genList (x: x + 1) 10);
              description = "Workspace where the window should be placed";
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

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = false;
        variables = [ "--all" ];
      };

      settings = {
        monitor = "${my.gui.display.name},${my.gui.display.string.width}x${my.gui.display.string.height}@${my.gui.display.string.refreshRate}Hz,auto,${my.gui.display.string.scale}";

        # uwsm-app doesn't seem to be reliable on startup
        exec-once = builtins.map (cmd: "uwsm app -- ${cmd}") [
          # set wallpaper
          (lib.getExe (
            pkgs.writeShellScriptBin "myswaybg" ''
              ${lib.getExe' pkgs.swaybg "swaybg"} -c "${my.theme.color.crust}" -m solid_color
            ''
          ))

          "myppd" # set power profile
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

          "${keys.mod}, ${keys.left}, movefocus, l"
          "${keys.mod}, ${keys.right}, movefocus, r"
          "${keys.mod}, ${keys.up}, movefocus, u"
          "${keys.mod}, ${keys.down}, movefocus, d"

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
          (builtins.map (value: "fullscreen, class:^(${value})$") [
            "waydroid.com.mojang.minecraftpe"
            "gamescope"
          ])

          (builtins.map (
            window:
            "workspace ${builtins.toString window.workspace} ${
              if window.silent then "silent" else ""
            }, ${window.type}:^(${window.id})$"
          ) cfg.windows)
        ];
      };

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
        entries = cfg.autostart;
      };
    };

    my.desktop = {
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
          id = "Waydroid";
          workspace = 7;
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
        }
      ];
    };
  };
}
