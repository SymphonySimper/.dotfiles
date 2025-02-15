{
  my,
  pkgs,
  lib,
  ...
}:
let
  keybinds = (import ./keybinds.nix { inherit my pkgs lib; });
  windows = import ./windows.nix;

  keys = {
    mod = "Mod4";
    left = "h";
    down = "j";
    up = "k";
    right = "l";
  };

  startup = lib.getExe (
    pkgs.writeShellScriptBin "startup" ''
      ${pkgs.swaybg}/bin/swaybg -c "${my.theme.color.crust}" -m solid_color;
      # brightness -r & # Restore Brightness
    ''
  );
in
{
  imports = lib.optionals my.gui.desktop.enable [
    ./scripts
    ./services
    ./utils

    ./xdg.nix
  ];

  config = lib.mkIf my.gui.desktop.enable {
    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    home.packages = with pkgs; [
      nautilus
    ];

    wayland.windowManager.sway = {
      enable = true;
      xwayland = true;
      wrapperFeatures.gtk = true;

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      config = {
        window = {
          border = 1;
          titlebar = false;
        };

        gaps.smartBorders = "on";
        startup = [ { command = "${startup}/bin/startup"; } ];
        defaultWorkspace = "workspace number 1";

        assigns = builtins.listToAttrs (
          builtins.map (workspaceNum: {
            name = if workspaceNum == "0" then "10" else workspaceNum;
            value = (
              builtins.concatMap (
                type:
                (builtins.map (id: {
                  ${type} = if type == "title" then "^${id}.*" else "^${id}$";
                }) windows.${workspaceNum}.${type})
              ) (builtins.attrNames windows.${workspaceNum})
            );
          }) (builtins.attrNames windows)
        );
        focus = {
          newWindow = "focus";
          followMouse = "no";
          wrapping = "yes";
        };
        workspaceAutoBackAndForth = false;

        floating.modifier = keys.mod;
        keybindings = lib.mkMerge [
          (builtins.listToAttrs (
            builtins.map (
              keybind:
              let
                prefix = if keybind.super then "${keys.mod}+" else "";
                action = if builtins.hasAttr "mod" keybind then "${keybind.mod}+${keybind.key}" else keybind.key;
                release = if keybind.cmd == "mytogglefps" then " --release " else "";
              in
              {
                name = "${release}${prefix}${action}";
                value = "exec ${keybind.cmd}";
              }
            ) keybinds
          ))

          # Moving around:
          (builtins.listToAttrs (
            builtins.concatMap
              (direction: [
                # Move your focus around
                {
                  name = "${keys.mod}+${keys.${direction}}";
                  value = "focus ${direction}";
                }
                # Move the focused window with the same, but add Shift
                {
                  name = "${keys.mod}+Shift+${keys.${direction}}";
                  value = "move ${direction}";
                }
              ])
              [
                "left"
                "down"
                "up"
                "right"
              ]
          ))

          # Workspaces:
          (builtins.listToAttrs (
            builtins.concatMap (
              num:
              let
                key = builtins.toString num;
                workspace = if num == 0 then "10" else key;
              in
              [
                # Switch to workspace
                {
                  name = "${keys.mod}+${key}";
                  value = "workspace number ${workspace}";
                }
                # Move focused container to workspace
                {
                  name = "${keys.mod}+Shift+${key}";
                  value = "move container to workspace number ${workspace}";
                }
              ]
            ) (lib.lists.range 0 9)
          ))

          {
            "${keys.mod}+q" = "kill";
            # Exit sway (logs you out of your Wayland session)
            "${keys.mod}+Shift+e" = "exit";
            # Make the current focus fullscreen
            "${keys.mod}+Shift+f" = "fullscreen";
          }
        ];

        output = {
          "*" = {
            bg = "${my.theme.color.crust} solid_color";
          };

          "${my.gui.display.name}" = rec {
            scale = "${builtins.toString my.gui.display.scale}";
            res = "${builtins.toString my.gui.display.width}x${builtins.toString my.gui.display.height}";
            mode = "${res}@${builtins.toString my.gui.display.refreshRate}Hz";
          };
        };

        # Do not enable!
        # Reason:
        # > Be aware that this setting can interfere with input handling in games
        # > and certain types of software (Gimp, Blender etc) that rely on
        # > simultaneous input from mouse and keyboard.
        # seat."*".hide_cursor = "when-typing enable";
        input."type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "disabled";
          middle_emulation = "enabled";
        };

        bars = [ ];

        colors = {
          focused = {
            border = "$lavender";
            background = "$base";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$lavender";
          };
          focusedInactive = {
            border = "$overlay0";
            background = "$base";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$base";
          };
          unfocused = {
            border = "$overlay0";
            background = "$base";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$base";
          };
          urgent = {
            border = "$peach";
            background = "$base";
            text = "$peach";
            indicator = "$overlay0";
            childBorder = "$base";
          };
          placeholder = {
            border = "$overlay0";
            background = "$base";
            text = "$text";
            indicator = "$overlay0";
            childBorder = "$base";
          };
          background = "$base";
        };
      };
    };
  };
}
