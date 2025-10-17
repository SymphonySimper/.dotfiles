{
  my,
  config,
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
              "-e"
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
    my.programs.desktop = {
      autostart = [ "alacritty" ];

      windows = [
        {
          id = "Alacritty";
          workspace = 1;
        }
      ];
    };

    programs.alacritty = {
      enable = true;
      settings = {
        general = {
          live_config_reload = true;
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

        mouse.hide_when_typing = true;

        # comment out below line to disable hints
        # hints.enabled = [ ];

        keyboard.bindings = [
          {
            key = "N";
            mods = "Control|Shift";
            action = "CreateNewWindow";
          }
          (mkProgramKeyBind {
            key = "Y";
            mods = "Control|Shift";
            cli = true;
            program = config.my.programs.file-manager.command;
          })
          (mkProgramKeyBind {
            key = "G";
            mods = "Control|Shift";
            cli = true;
            program = config.my.programs.vcs.tui.command;
          })
        ];
      };
    };
  };
}
