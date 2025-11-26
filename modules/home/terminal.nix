{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.terminal;
  runCommand = "myterminalrun";
in
{
  options.my.programs.terminal =
    (lib.my.mkCommandOption {
      category = "Terminal";
      command = "alacritty";
      args = {
        msg = "msg";
        newWindow = "create-window";
        command = "-e";
        run = runCommand;
      };
    })
    // {
      runScriptContent = lib.mkOption {
        description = "Terminal run script content";
        type = lib.types.lines;
        default = # sh
          ''${cfg.command} ${cfg.args.msg} ${cfg.args.newWindow} ${cfg.args.command} "$@" > /dev/null 2>&1'';
      };

      shell = lib.mkOption {
        type = lib.types.submodule {
          options = {
            program = lib.mkOption {
              description = "Program to run on launch";
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
          program = config.my.programs.shell.command;
          args = [ config.my.programs.shell.args.login ];
        };
      };
    };

  config = lib.mkMerge [
    { home.packages = [ (pkgs.writeShellScriptBin runCommand cfg.runScriptContent) ]; }

    (lib.mkIf my.gui.enable {
      my.programs = {
        desktop = {
          autostart = [
            {
              name = "alacritty-daemon";
              command = "${cfg.command} --daemon";
            }
          ];

          windows = [
            {
              id = "Alacritty";
              workspace = 1;
            }
          ];

          keybinds = [
            {
              mods = [ "super" ];
              key = "t";
              command = "${cfg.command} ${cfg.args.msg} ${cfg.args.newWindow}";
            }
          ];
        };
      };

      xdg.terminal-exec.enable = true;

      programs.alacritty = {
        enable = true;

        settings = {
          general = {
            live_config_reload = false;
            ipc_socket = true;
          };

          terminal.shell = cfg.shell;

          window = {
            decorations = "none";
            opacity = 1;
            startup_mode = "Maximized";
            padding = rec {
              x = 2;
              y = x;
            };
            dynamic_padding = true;
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

            {
              key = "G";
              mods = "Alt";
              command = {
                program = cfg.command;
                args = [
                  cfg.args.command
                  config.my.programs.vcs.tui.command
                ];
              };
            }

            {
              key = "Y";
              mods = "Alt";
              command = {
                program = cfg.command;
                args = [
                  cfg.args.command
                  config.my.programs.file-manager.command
                ];
              };
            }
          ];
        };
      };
    })
  ];
}
