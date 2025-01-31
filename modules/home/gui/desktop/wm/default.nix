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
    mod = "SUPER";
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
  imports = [
    ./scripts
    ./utils

    ./xdg.nix
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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = false;
      variables = [ "--all" ];
    };

    settings = {
      monitor = ",${my.gui.display.string.width}x${my.gui.display.string.height}@${my.gui.display.string.refreshRate}Hz,auto,${my.gui.display.string.scale}";

      exec-once = [ startup ];

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
        "${keys.mod} SHIFT, E, exit"
        "${keys.mod}, V, togglefloating"
        "${keys.mod} SHIFT, F, fullscreen"

        "${keys.mod}, ${keys.left}, movefocus, l"
        "${keys.mod}, ${keys.right}, movefocus, r"
        "${keys.mod}, ${keys.up}, movefocus, u"
        "${keys.mod}, ${keys.down}, movefocus, d"

        (builtins.map (
          keybind:
          let
            modKey = if keybind.super then "${keys.mod}" else "";
            action = if builtins.hasAttr "mod" keybind then "${lib.strings.toUpper keybind.mod}" else "";

            prefix = if modKey == "" && action == "" then "," else "${modKey} ${action},";
          in
          "${prefix} ${keybind.key}, exec, ${keybind.cmd}"
        ) keybinds)

        (builtins.concatMap
          (
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
          )
          [
            1
            2
            3
            4
            5
            6
            7
            8
            9
            0
          ]
        )
      ];

      windowrulev2 = lib.lists.flatten [
        # refer: https://github.com/hyprwm/Hyprland/pull/4704#issuecomment-2304649119
        "noborder, onworkspace:w[tv1] f[-1], floating:0"

        (builtins.map (value: "fullscreen, class:^(${value})$") [
          "waydroid.com.mojang.minecraftpe"
          "gamescope"
        ])

        (builtins.attrValues (
          builtins.mapAttrs (
            workspace: values:
            builtins.attrValues (
              builtins.mapAttrs (
                idType: ids:
                (builtins.map (
                  id:
                  let
                    idActualType = if idType == "app_id" then "class" else idType;
                  in
                  "workspace ${workspace} ${if id == "steam" then "silent" else ""}, ${idActualType}:^(${id})$"
                ) ids)
              ) values
            )
          ) windows
        ))
      ];
    };
  };
}
