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
  cfgM = config.my.programs.mux;

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
        program = if cli then cfg.run.command else program;
        args = if cli then [ (lib.strings.escapeShellArgs ([ program ] ++ args)) ] else args;
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
      run.command = lib.mkOption {
        type = lib.types.str;
        description = "Scrip to launch command in terminal";
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
        autostart = [ cfg.command ];

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
            command = cfg.command;
          }
        ];
      };

      terminal.run.command = lib.mkDefault (
        lib.getExe (
          pkgs.writeShellScriptBin "my-terminal-run" ''exec ${cfg.command} ${cfg.args.command} "$@"''
        )
      );
    };

    xdg.terminal-exec.enable = true;

    programs.alacritty = {
      enable = true;

      settings = {
        general = {
          live_config_reload = false;
          ipc_socket = false;
        };

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

          (mkProgramKeyBind {
            key = "T";
            mods = "Alt|Shift";
            cli = true;
            program = cfgM.command;
            args = [ cfgM.args.new ];
          })

          (mkProgramKeyBind {
            key = "G";
            mods = "Alt";
            cli = true;
            program = config.my.programs.vcs.tui.command;
          })

          (mkProgramKeyBind {
            key = "Y";
            mods = "Alt";
            cli = true;
            program = config.my.programs.file-manager.command;
          })
        ];
      };
    };
  };
}
