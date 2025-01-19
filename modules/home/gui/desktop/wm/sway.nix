{
  pkgs,
  lib,
  my,
  ...
}:
let
  keybinds = (
    import ./keybinds.nix {
      inherit pkgs;
      inherit lib;
      inherit my;
    }
  );
  windows = import ./windows.nix;

  keys = {
    mod = "Mod4";
    left = "h";
    down = "j";
    up = "k";
    right = "l";
  };
in
{
  config = lib.mkIf (my.gui.desktop.type == "wm") {
    wayland.windowManager.sway = {
      enable = true;
      checkConfig = false;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      xwayland = true;
      wrapperFeatures.gtk = true;
      config = {
        window = {
          border = 1;
          titlebar = false;
        };

        gaps.smartBorders = "on";

        startup = [ { command = "startup"; } ];

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

            "${keys.mod}+m" = "bar mode toggle";

            # Reload the configuration file
            "${keys.mod}+Shift+c" = "reload";

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
            # Or use $mod+[up|down|left|right]
            "${keys.mod}+Left" = "focus left";
            "${keys.mod}+Down" = "focus down";
            "${keys.mod}+Up" = "focus up";
            "${keys.mod}+Right" = "focus right";

            # Move the focused window with the same, but add Shift
            "${keys.mod}+Shift+${keys.left}" = "move left";
            "${keys.mod}+Shift+${keys.down}" = "move down";
            "${keys.mod}+Shift+${keys.up}" = "move up";
            "${keys.mod}+Shift+${keys.right}" = "move right";
            # Ditto, with arrow keys
            "${keys.mod}+Shift+Left" = "move left";
            "${keys.mod}+Shift+Down" = "move down";
            "${keys.mod}+Shift+Up" = "move up";
            "${keys.mod}+Shift+Right" = "move right";
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
            # Note: workspaces can have any name you want, not just numbers.
            # We just use 1-10 as the default.
            #
            # Layout stuff:
            #
            # You can "split" the current object of your focus with
            # $mod+b or $mod+v, for horizontal and vertical splits
            # respectively.
            "${keys.mod}+Shift+b" = "splith";
            "${keys.mod}+Shift+v" = "splitv";

            # Switch the current container between different layout styles
            "${keys.mod}+s" = "layout stacking";
            "${keys.mod}+w" = "layout tabbed";
            "${keys.mod}+e" = "layout toggle split";

            # Make the current focus fullscreen
            "${keys.mod}+Shift+f" = "fullscreen";

            # Toggle the current focus between tiling and floating mode
            "${keys.mod}+Shift+space" = "floating toggle";

            # Make window sticky
            "${keys.mod}+Shift+s" = "sticky toggle";

            # Swap focus between the tiling area and the floating area
            "${keys.mod}+space" = "focus mode_toggle";

            # Move focus to the parent container
            "${keys.mod}+a" = "focus parent";
            #
            # Scratchpad:
            #
            # Sway has a "scratchpad", which is a bag of holding for windows.
            # You can send windows there and get them back later.

            # Move the currently focused window to the scratchpad
            "${keys.mod}+Shift+minus" = "move scratchpad";

            # Show the next scratchpad window or hide the focused scratchpad window.
            # If there are multiple scratchpad windows, this command cycles through them.
            "${keys.mod}+minus" = "scratchpad show";

            # Switch to resize mode
            "${keys.mod}+r" = "mode \"resize\"";
          };

        # Resizing containers:
        modes."resize" = {
          # left will shrink the containers width
          # right will grow the containers width
          # up will shrink the containers height
          # down will grow the containers height
          "${keys.left}" = "resize shrink width 10px";
          "${keys.down}" = "resize grow height 10px";
          "${keys.up}" = "resize shrink height 10px";
          "${keys.right}" = "resize grow width 10px";

          # Ditto, with arrow keys
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";

          # Return to default mode
          "Return" = "mode \"default\"";
          "Escape" = "mode \"default\"";
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

        seat."*".hide_cursor = "when-typing enable";

        input."type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "disabled";
          middle_emulation = "enabled";
        };

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

        bars = [ ];
      };
    };
  };
}
