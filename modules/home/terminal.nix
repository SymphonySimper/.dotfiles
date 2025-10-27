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

  mkProgramKeyBind =
    {
      key,
      mods,
      cli ? true,
      program,
      args ? [ ],
    }:
    {
      inherit key mods;
      command = {
        program = if cli then "alacritty" else program;
        args =
          if cli then
            [
              cfg.args.command
              cfgSh.command
              cfgSh.args.login
              cfgSh.args.command
              (lib.strings.escapeShellArgs ([ program ] ++ args))
            ]
          else
            args;
      };
    };
in
{
  options.my.programs.terminal =
    (lib.my.mkCommandOption {
      category = "Terminal";
      command = "alacritty";
      args = {
        command = "-e";
        class = "--class";
      };
    })
    // {
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

        keyboard.bindings = [
          (mkProgramKeyBind {
            key = "T";
            mods = "Alt|Shift";
            cli = true;
            program = config.my.programs.mux.command;
            args = [ config.my.programs.mux.args.new ];
          })
        ];
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

        scrolling.history = 1000;

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
