{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.terminal;
  cfgSh = config.my.programs.shell;
in
{
  options.my.programs.terminal = (lib.my.mkCommandOption "Terminal" "alacritty") // {
    args = lib.mkOption {
      description = "Args that can be passed";
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      default = {
        command = "-e";
        class = "--class";
      };
    };

    shell = {
      command = lib.mkOption {
        description = "Default command to run on launch";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  config = lib.mkIf my.gui.enable {
    my.programs = {
      desktop = {
        autostart = [ "alacritty" ];

        windows = [
          {
            id = "Alacritty";
            workspace = 1;
          }
        ];
      };

      copy.of = [
        {
          from = "CONFIG/alacritty/alacritty.toml";
          to = "WINDOWS/alacritty/alacritty.toml";
        }
      ];
    };

    catppuccin.alacritty.enable = false;

    xdg.configFile."alacritty/unix.toml".source = (
      (pkgs.formats.toml { }).generate "unix.toml" {
        terminal.shell = {
          program = cfgSh.command;
          args = [
            cfgSh.args.login
          ]
          ++ (lib.lists.optionals (cfg.shell.command != null) [
            cfgSh.args.command
            cfg.shell.command
          ]);
        };
      }
    );

    programs.alacritty = {
      enable = true;

      settings = {
        general = {
          import = [
            "./unix.toml"
            "./windows.toml"
          ];

          live_config_reload = false;
          ipc_socket = false;
        };

        window = {
          decorations = "none";
          opacity = 1;
          # startup_mode = "Maximized";
          padding = rec {
            x = 2;
            y = x;
          };
          dynamic_padding = true;
        };

        scrolling.history = 10000;

        font = {
          size = 12;
          normal = {
            family = my.theme.font.mono;
            style = "Regular";
          };
          bold = {
            family = my.theme.font.mono;
            style = "Bold";
          };
          italic = {
            family = my.theme.font.mono;
            style = "Italic";
          };
          bold_italic = {
            family = my.theme.font.mono;
            style = "Bold Italic";
          };
        };

        cursor = {
          vi_mode_style = "Block";
          style = {
            blinking = "off";
            shape = "Block";
          };
        };

        mouse.hide_when_typing = true;

        # comment out below line to disable hints
        # hints.enabled = [ ];

        keyboard.bindings = [
          {
            key = "V";
            mods = "Alt";
            action = "ToggleViMode";
          }
          {
            key = "T";
            mods = "Alt";
            action = "CreateNewWindow";
          }
          {
            key = "M";
            mods = "Alt";
            action = "ToggleMaximized";
          }
          {
            key = "F";
            mods = "Alt|Shift";
            action = "ToggleFullscreen";
          }
        ];

        colors =
          (builtins.fromTOML (
            lib.my.mkGetThemeSource {
              package = "alacritty";
              filename = "NAME-FLAVOR.toml";
            }
          )).colors;
      };
    };
  };
}
