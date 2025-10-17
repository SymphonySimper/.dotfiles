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
              cfgSh.exe
              cfgSh.args.login
              cfgSh.args.cmd
              (lib.strings.escapeShellArgs ([ program ] ++ args))
            ]
          else
            args;
      };
    };
in
{
  options.my.programs.terminal = (lib.my.mkCommandOption "Terminal" "alacritty") // {
    exe = lib.mkOption {
      description = "Terminal package";
      type = lib.types.str;
      default = lib.getExe config.programs.alacritty.package;
      readOnly = true;
    };

    args = lib.mkOption {
      description = "Args that can be passed";
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      default = {
        cmd = "-e";
        class = "--class";
      };
    };

    shell = {
      cmd = lib.mkOption {
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
          program = cfgSh.exe;
          args = [
            cfgSh.args.login
          ]
          ++ (lib.lists.optionals (cfg.shell.cmd != null) [
            cfgSh.args.cmd
            cfg.shell.cmd
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
            program = "yazi";
          })
          (mkProgramKeyBind {
            key = "G";
            mods = "Control|Shift";
            cli = true;
            program = "lazygit";
          })
        ];
      };
    };
  };
}
