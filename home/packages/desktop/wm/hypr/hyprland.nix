{ userSettings, ... }:
let
  customKeybinds = (import ../keybinds.nix { inherit userSettings; });
in

{
  wayland.windowManager.hyprland = {
    enable = userSettings.desktop.name == "hyprland";
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      # Settings
      "monitor" = ",2880x1800@60,auto,1.6";
      env = "XCURSOR_SIZE,12";

      exec-once = [ "startup" ];

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
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        "col.active_border" = "$mauve";
        "col.inactive_border" = "$base";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;

        blur = {
          enabled = false;
        };

        drop_shadow = false;
        dim_inactive = false;
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
        new_status = "master";
      };

      gestures = {
        workspace_swipe = true;
      };

      # "device:epic-mouse-v1" = {
      #   sensitivity = -0.5;
      # };

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
        "workspace: 2, class:^(Chromium-browser)$"
        "workspace: 2, class:^(Brave-browser)$"
        "workspace: 3, class:^(com.github.johnfactotum.Foliate)$"
        "workspace: 4, class:^(mpv)$"
        "workspace: 5 silent, class:^(thunderbird)$"
        "workspace: 6 silent, class:^(discord)$"
        "workspace: 9 silent, class:^(steam)$"
        "workspace: 10 silent, title:^(meet.google.com is sharing your screen.)$"

        # xwaylandvideobridge KDE
        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$ "
      ];

      # Keybinds
      "$mainMod" = "SUPER";

      # Actions
      bind = [
        "$mainMod, q, killactive,"
        "$mainMod SHIFT, Q, exit,"

        # Apps
        "$mainMod, ${customKeybinds.terminal.default.key}, exec, ${customKeybinds.terminal.default.cmd}"
        "$mainMod, ${customKeybinds.browser.default.key}, exec, ${customKeybinds.browser.default.cmd}"
        "$mainMod, ${customKeybinds.launcher.default.key}, exec, ${customKeybinds.launcher.default.cmd}"
        # "$mainMod, E, exec, nautilus"
        "$mainMod, B, exec, killall -SIGUSR1 .waybar-wrapped" # Toggle waybar
        "$mainMod SHIFT, B, exec, killall -SIGUSR2 .waybar-wrapped" # Restart waybar

        # Toggle
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod SHIFT, F, fullscreen"

        # Global binds
        # bind = $mainMod, F8, pass, ^(discord)$ # Toggle mute in discord

        # Brightnes
        "$mainMod, ${customKeybinds.brightness.down.key}, exec, ${customKeybinds.brightness.down.cmd}"
        "$mainMod, ${customKeybinds.brightness.up.key}, exec, ${customKeybinds.brightness.up.cmd}"

        # Volume
        "$mainMod, ${customKeybinds.volume.down.key}, exec, ${customKeybinds.volume.down.cmd}"
        "$mainMod, ${customKeybinds.volume.up.key}, exec, ${customKeybinds.volume.up.cmd}"
        "$mainMod ${customKeybinds.volume.toggle.mod}, ${customKeybinds.volume.toggle.key}, exec, ${customKeybinds.volume.toggle.cmd}"

        # Mic
        "$mainMod, ${customKeybinds.mic.toggle.key}, exec, ${customKeybinds.mic.toggle.cmd}"

        # Screenshot
        "$mainMod, ${customKeybinds.screenshot.screen.key}, exec, ${customKeybinds.screenshot.screen.cmd}"
        "$mainMod ${customKeybinds.screenshot.window.mod}, ${customKeybinds.screenshot.window.key}, exec, ${customKeybinds.screenshot.window.cmd}"
        "$mainMod ${customKeybinds.screenshot.region.mod}, ${customKeybinds.screenshot.region.key}, exec, ${customKeybinds.screenshot.region.cmd}"

        # Caffiene
        "$mainMod, ${customKeybinds.caffiene.toggle.key}, exec, ${customKeybinds.caffiene.toggle.cmd}"

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
}
