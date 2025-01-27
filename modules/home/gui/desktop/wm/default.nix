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

  # wallpaper = pkgs.writeShellScriptBin "wallpaper" ''
  #   ${pkgs.swaybg}/bin/swaybg -c "${my.theme.color.crust}" -m solid_color;
  # '';

  startup = pkgs.writeShellScriptBin "startup" ''
    brightness -r & # Restore Brightness
  '';
in
{
  imports = [
    ./scripts
    ./utils
    ./xdg
  ];

  services = {
    udiskie.enable = true;
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };

  home.packages = with pkgs; [
    nautilus
  ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = true;
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
      keybindings =
        (builtins.listToAttrs (
          builtins.map (
            keybind:
            let
              prefix = (if keybind.super then "${keys.mod}+" else "");
              action = (if builtins.hasAttr "mod" keybind then "${keybind.mod}+${keybind.key}" else keybind.key);
            in
            {
              name = "${prefix}${action}";
              value = "exec ${keybind.cmd}";
            }
          ) keybinds
        ))
        // {
          "${keys.mod}+q" = "kill";
          # Exit sway (logs you out of your Wayland session)
          "${keys.mod}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
          #
          # Moving around:
          #
          # Move your focus around
          "${keys.mod}+${keys.left}" = "focus left";
          "${keys.mod}+${keys.down}" = "focus down";
          "${keys.mod}+${keys.up}" = "focus up";
          "${keys.mod}+${keys.right}" = "focus right";
          # Move the focused window with the same, but add Shift
          "${keys.mod}+Shift+${keys.left}" = "move left";
          "${keys.mod}+Shift+${keys.down}" = "move down";
          "${keys.mod}+Shift+${keys.up}" = "move up";
          "${keys.mod}+Shift+${keys.right}" = "move right";

          #
          # Workspaces:
          #
          # Switch to workspace
          "${keys.mod}+1" = "workspace number 1";
          "${keys.mod}+2" = "workspace number 2";
          "${keys.mod}+3" = "workspace number 3";
          "${keys.mod}+4" = "workspace number 4";
          "${keys.mod}+5" = "workspace number 5";
          "${keys.mod}+6" = "workspace number 6";
          "${keys.mod}+7" = "workspace number 7";
          "${keys.mod}+8" = "workspace number 8";
          "${keys.mod}+9" = "workspace number 9";
          "${keys.mod}+0" = "workspace number 10";
          # Move focused container to workspace
          "${keys.mod}+Shift+1" = "move container to workspace number 1";
          "${keys.mod}+Shift+2" = "move container to workspace number 2";
          "${keys.mod}+Shift+3" = "move container to workspace number 3";
          "${keys.mod}+Shift+4" = "move container to workspace number 4";
          "${keys.mod}+Shift+5" = "move container to workspace number 5";
          "${keys.mod}+Shift+6" = "move container to workspace number 6";
          "${keys.mod}+Shift+7" = "move container to workspace number 7";
          "${keys.mod}+Shift+8" = "move container to workspace number 8";
          "${keys.mod}+Shift+9" = "move container to workspace number 9";
          "${keys.mod}+Shift+0" = "move container to workspace number 10";

          # Make the current focus fullscreen
          "${keys.mod}+Shift+f" = "fullscreen";
        };

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
}
