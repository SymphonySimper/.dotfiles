{ den, lib, ... }:
let
  keys = {
    mod = {
      super = "<Super>";
      ctrl = "<Control>";
      alt = "<Alt>";
      shift = "<Shift>";
    };
  };
in
{
  den.default.includes = [ den.aspects.options.desktop.gnome.keybinds ];

  den.aspects.options.desktop.gnome.keybinds = {
    homeManager.options.desktop.gnome.keybinds = lib.mkOption {
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
          };
        }
      );
    };
  };

  den.aspects.desktop.gnome = {
    homeManager =
      { config, lib, ... }:
      let
        cfg = config.desktop.gnome;

        customKeybinds = (
          builtins.listToAttrs (
            lib.lists.imap0 (i: bind: {
              name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}";
              value = {
                name = if builtins.hasAttr "name" bind then bind.name else bind.command;
                binding = builtins.concatStringsSep "" (
                  (lib.lists.optionals (bind.mods != null) (map (mod: keys.mod.${mod}) bind.mods)) ++ [ bind.key ]
                );
                command = bind.command;
              };
            }) cfg.keybinds
          )
        );
      in
      {
        dconf.settings = customKeybinds // {
          "org/gnome/mutter" = {
            overlay-key = "Super_L";
          };

          "org/gnome/desktop/input-sources" = {
            xkb-options = [
              "terminate:ctrl_alt_bksp" # default for xkb-options
              "lv3:rwin_switch" # alternate characters key: setting it to right super to free right alt
              "ctrl:nocaps" # caps lock as ctrl
            ];
          };

          "org/gnome/desktop/wm/keybindings" = {
            minimize = [ ];
            close = [ "<Super>q" ]; # close app
            toggle-maximized = [ "<Super>f" ];
            toggle-fullscreen = [ "<Super><Shift>f" ];

            switch-windows = [ "<Alt>Tab" ];
            switch-windows-backward = [ "<Alt><Shift>Tab" ];
            ## disable switch-applications binding as sometimes it just takes over <Alt>Tab
            switch-applications = [ ];
            switch-applications-backward = [ ];

            switch-to-workspace-left = [ "<Super>j" ];
            switch-to-workspace-right = [ "<Super>k" ];
            move-to-workspace-left = [ "<Super><Shift>j" ];
            move-to-workspace-right = [ "<Super><Shift>k" ];

            begin-move = [ "<Super>m" ];
            begin-resize = [ "<Super>r" ];

            switch-input-source = [ ];
            switch-input-source-backward = [ ];
          };

          "org/gnome/shell/keybindings" = {
            screenshot = [ "<Super>F11" ];
            show-screenshot-ui = [ "<Super><Shift>F11" ];
            show-screen-recording-ui = [ "<Super><Control>F11" ];
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            mic-mute = [ "F8" ];
            play = [ "F7" ];
            volume-down = [ "<Super>F2" ];
            volume-mute = [ "<Super><Shift>F2" ];
            volume-up = [ "<Super>F3" ];

            screensaver = [ "<Super>Escape" ];
            logout = [ "<Super><Control>Escape" ];
            shutdown = [ "<Super><Alt>Escape" ];
            reboot = [ "<Super><Alt><Control>Escape" ];

            home = [ "<Super><Shift>e" ];
            www = [ "<Super>b" ]; # launch browser

            custom-keybindings = map (name: "/${name}/") (builtins.attrNames customKeybinds);
          };

          "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = [ ];
          };
        };
      };
  };
}
