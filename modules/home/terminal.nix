{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.terminal;

  files = {
    theme = "theme.toml";
    extra = "extra.toml";
    config = "alacritty.toml";
  };
in
{
  options.my.programs.terminal =
    (lib.my.mkCommandOption {
      category = "Terminal";
      command = "alacritty";
      args = {
        command = "-e";
      };
    })
    // {
      shell = lib.mkOption {
        type = lib.types.submodule {
          options = {
            command = lib.mkOption {
              description = "Command to run on launch";
              type = lib.types.str;
            };

            args = lib.mkOption {
              description = "Args for the program";
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
          };
        };

        default = {
          command = config.my.programs.shell.command;
          args = [ ];
        };
      };
    };

  config = lib.mkMerge [
    (lib.mkIf my.gui.enable {
      my.programs = {
        desktop = {
          keybinds = [
            {
              mods = [ "super" ];
              key = "t";
              command = cfg.command;
            }
          ];
        };

        copy.of =
          (builtins.map (file: {
            from = "CONFIG/alacritty/${file}";
            to = "WINDOWS/alacritty/${file}";
          }))
            [
              files.config
              files.theme
            ];
      };

      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "Alacritty.desktop" ];
      };

      catppuccin.alacritty.enable = false;

      xdg.configFile = {
        "alacritty/${files.theme}".source = lib.my.mkGetThemeSource {
          package = "alacritty";
          filename = "NAME-FLAVOR.toml";
          returnFile = true;
        };

        "alacritty/${files.extra}".source =
          let
            tomlFormat = pkgs.formats.toml { };
          in
          tomlFormat.generate files.extra {
            terminal.shell = {
              program = cfg.shell.command;
              args = cfg.shell.args;
            };
          };
      };

      programs.alacritty = {
        enable = true;

        settings = {
          general = {
            import = [
              files.theme
              files.extra
            ];

            live_config_reload = false;
            ipc_socket = false;
          };

          window = {
            decorations = "none";
            opacity = 1;
            startup_mode = "Maximized";

            dynamic_padding = true;
            padding = rec {
              x = 2;
              y = x;
            };
          };

          scrolling.history = 1000;
          selection.save_to_clipboard = true;

          font = {
            size = 12;

            normal = {
              family = my.theme.font.mono;
              style = "Regular";
            };
          };

          cursor = {
            vi_mode_style = "Block";

            style = {
              blinking = "off";
              shape = "Block";
            };
          };

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
        };
      };
    })
  ];
}
