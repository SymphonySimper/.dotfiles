{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      # Color
      "$rosewaterAlpha" = "f5e0dc";
      "$flamingoAlpha" = "f2cdcd";
      "$pinkAlpha" = "f5c2e7";
      "$mauveAlpha" = "cba6f7";
      "$redAlpha" = "f38ba8";
      "$maroonAlpha" = "eba0ac";
      "$peachAlpha" = "fab387";
      "$yellowAlpha" = "f9e2af";
      "$greenAlpha" = "a6e3a1";
      "$tealAlpha" = "94e2d5";
      "$skyAlpha" = "89dceb";
      "$sapphireAlpha" = "74c7ec";
      "$blueAlpha" = "89b4fa";
      "$lavenderAlpha" = "b4befe";

      "$textAlpha" = "cdd6f4";
      "$subtext1Alpha" = "bac2de";
      "$subtext0Alpha" = "a6adc8";

      "$overlay2Alpha" = "9399b2";
      "$overlay1Alpha" = "7f849c";
      "$overlay0Alpha" = "6c7086";

      "$surface2Alpha" = "585b70";
      "$surface1Alpha" = "45475a";
      "$surface0Alpha" = "313244";

      "$baseAlpha" = "1e1e2e";
      "$mantleAlpha" = "181825";
      "$crustAlpha" = "11111b";

      "$rosewater" = "0xfff5e0dc";
      "$flamingo" = "0xfff2cdcd";
      "$pink" = "0xfff5c2e7";
      "$mauve" = "0xffcba6f7";
      "$red" = "0xfff38ba8";
      "$maroon" = "0xffeba0ac";
      "$peach" = "0xfffab387";
      "$yellow" = "0xfff9e2af";
      "$green" = "0xffa6e3a1";
      "$teal" = "0xff94e2d5";
      "$sky" = "0xff89dceb";
      "$sapphire" = "0xff74c7ec";
      "$blue" = "0xff89b4fa";
      "$lavender" = "0xffb4befe";

      "$text" = "0xffcdd6f4";
      "$subtext1" = "0xffbac2de";
      "$subtext0" = "0xffa6adc8";

      "$overlay2" = "0xff9399b2";
      "$overlay1" = "0xff7f849c";
      "$overlay0" = "0xff6c7086";

      "$surface2" = "0xff585b70";
      "$surface1" = "0xff45475a";
      "$surface0" = "0xff313244";

      "$base" = "0xff1e1e2e";
      "$mantle" = "0xff181825";
      "$crust" = "0xff11111b";

      # Settings
      "monitor" = ",1920x1080@60,auto,1.0";
      env = "XCURSOR_SIZE,12";

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat";
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "$surface0";
        "col.inactive_border" = "$base";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;

        blur = {
          enabled = false;
        };

        drop_shadow = false;
        dim_inactive = true;
        dim_strength = 0.4;
      };

      animations = {
        enabled = false;
      };

      dwindle = {
        force_split = "2";
        no_gaps_when_only = "0";
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = true;
      };

      "device:epic-mouse-v1" = {
        sensitivity = -0.5;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      # Window rules
      windowrulev2 = [
        "workspace: 1, class:^(Alacritty)$"
        "workspace: 2 silent, class:^(firefox)$"
        "workspace: 2, class:^(Brave-browser)$"
        "workspace: 3, class:^(com.github.johnfactotum.Foliate)$"
        "workspace: 4, class:^(mpv)$"
        "workspace: 5 silent, class:^(thunderbird)$"
        "workspace: 6 silent, class:^(discord)$"
        "workspace: 7 silent, title:^(Spotify)$"
        "workspace: 9 silent, class:^(steam)$"
        "workspace: 10 silent, title:^(meet.google.com is sharing your screen.)$"

        # xwaylandvideobridge KDE
        "windowrulev2 = opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "windowrulev2 = noanim,class:^(xwaylandvideobridge)$"
        "windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$"
        "windowrulev2 = maxsize 1 1,class:^(xwaylandvideobridge)$"
        "windowrulev2 = noblur,class:^(xwaylandvideobridge)$ "
      ];

      # Keybinds
      "$mainMod" = "SUPER";

      # Actions
      bind = [
        "$mainMod, q, killactive,"
        "$mainMod SHIFT, Q, exit,"

        # Apps
        "$mainMod, Return, exec, terminal tmux"
        "$mainMod SHIFT, Return, exec, terminal"
        "$mainMod CTRL SHIFT, Return, exec, terminal attach"
        "$mainMod, E, exec, nautilus"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, F, exec, firefox"
        "$mainMod, B, exec, killall -SIGUSR1 waybar" # Toggle waybar
        "$mainMod SHIFT, B, exec, killall -SIGUSR2 waybar" # Restart waybar

        # Toggle
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod SHIFT, F, fullscreen"

        # Global binds
        # bind = $mainMod, F8, pass, ^(discord)$ # Toggle mute in discord

        # Adjust brightnes
        "$mainMod, F5, exec, brightness -u"
        "$mainMod, F6, exec, brightness -d"

        # Adjust volume
        "$mainMod, F3, exec, volume -u"
        "$mainMod, F4, exec, volume -d"
        "$mainMod SHIFT, F3, exec, volume -U"
        "$mainMod SHIFT, F4, exec, volume -D"
        "$mainMod, F2, exec, volume -m"
        ", F8, exec, volume -M" # Toggle mic

        # Take screenshot
        "$mainMod, PRINT, exec, screenshot -w"
        ", PRINT, exec, screenshot -s"
        "$mainMod SHIFT, PRINT, exec, screenshot -r"

        # Control Spotify
        ", F7, exec, myspotify o"
        "SHIFT, F7, exec, myspotify n"
        "CTRL, F7, exec, myspotify p"

        # Move focus with mainMod + arrow keys
        "$mainMod, l, movefocus, l"
        "$mainMod, h, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Swap window 
        "$mainMod SHIFT, H, swapwindow, l"
        "$mainMod SHIFT, L, swapwindow, r"
        "$mainMod SHIFT, K, swapwindow, u"
        "$mainMod SHIFT, J, swapwindow, d"

        # Move window 
        "$mainMod CTRL SHIFT, H, movewindow, l"
        "$mainMod CTRL SHIFT, L, movewindow, r"
        "$mainMod CTRL SHIFT, K, movewindow, u"
        "$mainMod CTRL SHIFT, J, movewindow, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # SUPER + ` to go between previous tabs
        "$mainMod, code:49, workspace, previous"


        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1 "
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow "
      ];

    };

    extraConfig = ''
      exec-once = "$HOME"/.config/hypr/scripts/random-wallpaper.sh
      exec-once = waybar --config ~/.config/waybar/config.json --style ~/.config/waybar/style.css
      exec-once = dunst
      # exec-once = xwaylandvideobridge
      exec-once = startup
      exec-once = dir="$(dirname $(grep -l coretemp /sys/class/hwmon/hwmon*/name))"; ln -sf $dir/temp1_input /tmp/temperature &
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP


      # will switch to a submap called resize
      bind = ALT , R, submap, resize

      # will start a submap called "resize"
      submap = resize

      # sets repeatable binds for resizing the active window
      binde = , l, resizeactive, 10 0
      binde = , h, resizeactive, -10 0
      binde = , k, resizeactive, 0 -10
      binde = , j, resizeactive, 0 10

      # use reset to go back to the global submap
      bind = , escape, submap, reset 

      # will reset the submap, meaning end the current one and return to the global one
      submap = reset
    '';
  };

  home.packages = with pkgs; [
    waybar
    hyprshot
    hyprpaper
  ];
}
