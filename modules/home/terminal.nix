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
          startup_mode = "Maximized";
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
            key = "V";
            mods = "Alt|Shift";
            action = "ToggleViMode";
          }
          {
            key = "N";
            mods = "Alt|Shift";
            action = "CreateNewWindow";
          }
          {
            key = "M";
            mods = "Alt|Shift";
            action = "ToggleMaximized";
          }
          {
            key = "F";
            mods = "Alt|Shift";
            action = "ToggleFullscreen";
          }
          (mkProgramKeyBind {
            key = "Y";
            mods = "Alt|Shift";
            cli = true;
            program = config.my.programs.file-manager.command;
          })
          (mkProgramKeyBind {
            key = "G";
            mods = "Alt|Shift";
            cli = true;
            program = config.my.programs.vcs.tui.command;
          })
        ];
      };
    };

    programs.rio = {
      enable = true;

      settings = {
        use-fork = false;
        hide-mouse-cursor-when-typing = true;

        padding-x = 2;
        padding-y = [
          2
          0
        ];

        cursor = {
          shape = "block";
          blinking = false;
        };

        fonts = {
          size = 16;
          family = my.theme.font.mono;
        };

        colors = {
          split = lib.mkForce my.theme.color.mauve;
          tabs = lib.mkForce my.theme.color.overlay0;
          tabs-active-highlight = lib.mkForce my.theme.color.mauve;
        };

        window = {
          mode = "Maximized";
          decorations = "Disabled";
        };

        editor.program = config.my.programs.editor.command;

        bindings.keys = [
          {
            key = "c";
            "with" = "control | shift";
            action = "Copy";
          }
          {
            key = "p";
            "with" = "control | shift";
            action = "Paste";
          }

          {
            key = "t";
            "with" = "alt";
            action = "CreateTab";
          }
          {
            key = "w";
            "with" = "alt";
            action = "CloseSplitOrTab";
          }

          {
            key = "\\";
            "with" = "alt | shift";
            action = "SplitRight";
          }
          {
            key = "-";
            "with" = "alt | shift";
            action = "SplitDown";
          }

          {
            key = "k";
            "with" = "alt";
            action = "SelectPrevSplitOrTab";
          }
          {
            key = "j";
            "with" = "alt";
            action = "SelectNextSplitOrTab";
          }

          {
            key = "k";
            "with" = "alt | shift";
            action = "MoveDividerUp";
          }
          {
            key = "j";
            "with" = "alt | shift";
            action = "MoveDividerDown";
          }
          {
            key = "h";
            "with" = "alt | shift";
            action = "MoveDividerLeft";
          }
          {
            key = "l";
            "with" = "alt | shift";
            action = "MoveDividerRight";
          }
        ]
        ++ (builtins.genList (num: {
          key = builtins.toString (if num == 9 then 0 else num + 1);
          "with" = "alt";
          action = "SelectTab(${builtins.toString num})";
        }) 10);

        platform = {
          linux = {
            shell = {
              program = "${config.my.programs.shell.command}";
              args = [ config.my.programs.shell.args.login ];
            };
          };

          windows = {
            shell = {
              program = "pwsh";
              args = [ "-l" ];
            };
          };
        };
      };
    };
  };
}
