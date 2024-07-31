{ userSettings, pkgs, ... }:
let
  commonKeys = (import ./keybinds.nix);
  customColors = (import ../../../../assets/colors.nix).mocha;

  keys = {
    mod = "Mod4";
    left = "h";
    down = "j";
    up = "k";
    right = "l";
  };

  swaybarCommand = pkgs.writeShellScriptBin "my-sway-bar" ''
    function create_sepeartor() {
      echo "<span foreground='${customColors.overlay0}'>$1</span>"
    }

    function create_block() {
      full_text="$(create_sepeartor '[') $1 $(create_sepeartor ']')"
      color="$2"
      background="$3"
      min_width="100%"
      align="center"
      separator=true
      markup="pango"
      echo '{'
      echo "\"full_text\": \"$full_text\","
      echo "\"color\": \"$color\","
      echo "\"background\": \"$background\","
      echo "\"min_width\": \"$min_width\","
      echo "\"align\": \"$align\","
      echo "\"separator\": $separator,"
      echo "\"markup\": \"$markup\","
      echo '},'
    }

    echo '{ "version": 1, "click_event": false }'
    echo '['
    while true; do
      # Caffiene
      caffiene_inactive=$(caffiene -g)
      if [ $caffiene_inactive -eq 1 ]; then
        caffiene_status="DISABLED"
        caffiene_color="${customColors.overlay0}"
      else
        caffiene_status="ENABLED"
        caffiene_color="${customColors.peach}"
      fi

      # Date
      date_status=$(date "+%H:%M %d/%m/%Y")

      # Battery
      battery_status=$(cat /sys/class/power_supply/BAT0/status)
      battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
      if [ $battery_capacity -gt 80 ] && [[ $battery_status == 'Charging' ]]; then
        notify replace 'my-battery-status' "Battery is greater than 80% ($battery_capacity) unplug the charger" -u critical
      fi
      if [ $battery_capacity -le 40 ] && [[ $battery_status == 'Discharging' ]]; then
        notify replace 'my-battery-status' "Battery is less than 40% ($battery_capacity) plug the charger" -u critical
      fi
      case "$battery_status" in
      'Charging') battery_status_color="${customColors.green}" ;;
      'Discharging') battery_status_color="${customColors.maroon}" ;;
      esac
      if [ $battery_capacity -gt 80 ]; then
        battery_capacity_color="${customColors.maroon}"
      elif [ $battery_capacity -gt 50 ]; then
        battery_capacity_color="${customColors.green}"
      elif [ $battery_capacity -gt 20 ]; then
        battery_capacity_color="${customColors.yellow}"
      else
        battery_capacity_color="${customColors.red}"
      fi

      # Audio
      audio_mute=$(volume -gm)
      audio_volume=$(volume -gV)
      if [ $audio_mute -eq 0 ]; then
        audio="MUTED"
        audio_color="${customColors.red}"
      else
        audio="$audio_volume"
        if [ $audio_volume -gt 80 ]; then
          audio_color="${customColors.red}"
        elif [ $audio_volume -gt 50 ]; then
          audio_color="${customColors.maroon}"
        elif [ $audio_volume -gt 20 ]; then
          audio_color="${customColors.yellow}"
        else
          audio_color="${customColors.green}"
        fi
      fi

      # Mic
      mic_mute=$(volume -gM)
      if [ $mic_mute -eq 0 ]; then
        mic="MUTED"
        mic_color="${customColors.green}"
      else
        mic="UNMUTED"
        mic_color="${customColors.red}"
      fi

      # Brightness
      brightness_status=$(brightness -g)
      if [ $brightness_status -gt 80 ]; then
        brightness_color="${customColors.red}"
      elif [ $brightness_status -gt 50 ]; then
        brightness_color="${customColors.maroon}"
      elif [ $brightness_status -gt 20 ]; then
        brightness_color="${customColors.yellow}"
      else
        brightness_color="${customColors.green}"
      fi

      echo '['
        create_block "$brightness_status%" "$brightness_color"
        create_block "$mic" "$mic_color"
        create_block "$audio%" "$audio_color"
        create_block "<span foreground='$battery_status_color'>$battery_status</span> <span foreground='$battery_capacity_color'>$battery_capacity%</span>"
        create_block "$date_status" ${customColors.text}
        create_block "$caffiene_status" "$caffiene_color"
      echo '],'
      sleep 2s
    done
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    systemd.enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = keys.mod;
      left = keys.left;
      down = keys.down;
      up = keys.up;
      right = keys.right;

      menu = "${userSettings.programs.launcher}";

      window = {
        border = 1;
        titlebar = false;
      };

      gaps = {
        smartBorders = "on";
      };

      startup = [ { command = "startup"; } ];

      defaultWorkspace = "workspace number 1";
      assigns = {
        "0" = [ { title = "^meet.google.com is sharing your screen.$"; } ];
        "1" = [ { app_id = "^(Alacritty|footclient|foot)$"; } ];
        "2" = [ { app_id = "^(firefox|chromium-browser|Brave-browser)$"; } ];
        "3" = [ { app_id = "^com.github.johnfactotum.Foliate$"; } ];
        "4" = [ { app_id = "^mpv$"; } ];
        "5" = [ { class = "^steam$"; } ];
        "9" = [ { app_id = "^$"; } ];
      };

      workspaceAutoBackAndForth = true;
      floating.modifier = modifier;
      keybindings = {
        "${keys.mod}+Return" = "exec ${
          if userSettings.programs.terminal == "foot" then "footclient" else userSettings.programs.terminal
        }";
        "${keys.mod}+f" = "exec ${userSettings.programs.browser}";
        "${keys.mod}+d" = "exec ${menu} --show drun";
        "${keys.mod}+q" = "kill";

        # Brightness
        "${keys.mod}+${commonKeys.brightness.down.key}" = "exec ${commonKeys.brightness.down.cmd}";
        "${keys.mod}+${commonKeys.brightness.up.key}" = "exec ${commonKeys.brightness.up.cmd}";

        # Volume
        "${keys.mod}+${commonKeys.volume.down.key}" = "exec ${commonKeys.volume.down.cmd}";
        "${keys.mod}+${commonKeys.volume.up.key}" = "exec ${commonKeys.volume.up.cmd}";
        "${keys.mod}+${commonKeys.volume.toggle.mod}+${commonKeys.volume.toggle.key}" = "exec ${commonKeys.volume.toggle.cmd}";

        # Mic
        "${keys.mod}+${commonKeys.mic.toggle.key}" = "exec ${commonKeys.mic.toggle.cmd}";

        # Screenshot
        "${keys.mod}+${commonKeys.screenshot.screen.key}" = "exec ${commonKeys.screenshot.screen.cmd}";
        "${keys.mod}+${commonKeys.screenshot.window.mod}+${commonKeys.screenshot.window.key}" = "exec ${commonKeys.screenshot.window.cmd}";
        "${keys.mod}+${commonKeys.screenshot.region.mod}+${commonKeys.screenshot.region.key}" = "exec ${commonKeys.screenshot.region.cmd}";

        # Caffiene
        "${keys.mod}+${commonKeys.caffiene.toggle.key}" = "exec ${commonKeys.caffiene.toggle.cmd}";

        # Spotify
        "${keys.mod}+${commonKeys.spotify.toggle.key}" = "exec ${commonKeys.spotify.toggle.cmd}";
        "${keys.mod}+${commonKeys.spotify.prev.mod}+${commonKeys.spotify.prev.key}" = "exec ${commonKeys.spotify.prev.cmd}";
        "${keys.mod}+${commonKeys.spotify.next.mod}+${commonKeys.spotify.next.key}" = "exec ${commonKeys.spotify.next.cmd}";

        # Bar
        "${keys.mod}+m" = "bar mode toggle";

        # Reload the configuration file
        "${keys.mod}+Shift+c" = "reload";

        # Exit sway (logs you out of your Wayland session)
        "${keys.mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
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
        "${keys.mod}+b" = "splith";
        "${keys.mod}+v" = "splitv";

        # Switch the current container between different layout styles
        "${keys.mod}+s" = "layout stacking";
        "${keys.mod}+w" = "layout tabbed";
        "${keys.mod}+e" = "layout toggle split";

        # Make the current focus fullscreen
        "${keys.mod}+Shift+f" = "fullscreen";

        # Toggle the current focus between tiling and floating mode
        "${keys.mod}+Shift+space" = "floating toggle";

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
      modes = {
        # Resizing containers:
        "resize" = {
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
      };

      output = {
        # "*" = {
        #   bg = "${userSettings.wallpaper} fill #000000";
        # };
        "eDP-1" = rec {
          scale = "1.5";
          res = "2880x1800";
          mode = "${res}@60Hz";
        };
      };

      seat = {
        "*" = {
          hide_cursor = "when-typing enable";
        };
      };

      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "disabled";
          middle_emulation = "enabled";
        };
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

      bars = [
        {
          statusCommand = pkgs.lib.getExe swaybarCommand;

          extraConfig = ''
            pango_markup enabled
            # modifier ""
          '';

          position = "bottom";
          mode = "hide";
          hiddenState = "hide";
          fonts = {
            names = [
              userSettings.font.sans
              userSettings.font.glyph
            ];
            style = "Regular Semi-Condensed";
            size = 11.0;
          };
          colors = {
            background = "$base";
            statusline = "$text";
            focusedStatusline = "$text";
            focusedSeparator = "$base";
            focusedWorkspace = {
              border = "$base";
              background = "$base";
              text = "$green";
            };
            activeWorkspace = {
              border = "$base";
              background = "$base";
              text = "$blue";
            };
            inactiveWorkspace = {
              border = "$base";
              background = "$base";
              text = "$surface1";
            };
            urgentWorkspace = {
              border = "$base";
              background = "$base";
              text = "$surface1";
            };
            bindingMode = {
              border = "$base";
              background = "$base";
              text = "$surface1";
            };
          };
        }
      ];
    };
  };
}
