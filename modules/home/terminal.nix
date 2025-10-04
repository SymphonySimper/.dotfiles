{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.terminal;

in
{
  options.my.programs.terminal = (lib.my.mkNameOption "Terminal" "alacritty") // {
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
          live_config_reload = false;
          ipc_socket = false;
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

        scrolling.history = 0;

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

        terminal.shell =
          let
            cfgSh = config.my.programs.shell;
          in
          {
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

        # disable hints
        hints.enabled = [ ];
      };
    };
  };
}
