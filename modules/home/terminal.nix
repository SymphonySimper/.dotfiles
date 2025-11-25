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
        command = "-e";
        run = runCommand;
      };
    })
    // {
      runScriptContent = lib.mkOption {
        description = "Terminal run script content";
        type = lib.types.lines;
        default = # sh
          ''${cfg.command} ${cfg.args.command} "$@" > /dev/null 2>&1'';
      };

      shell = {
        command = lib.mkOption {
          description = "Default command to run on launch";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
    };

  config = lib.mkMerge [
    { home.packages = [ (pkgs.writeShellScriptBin runCommand cfg.runScriptContent) ]; }

    (lib.mkIf my.gui.enable {
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
      };

      xdg.terminal-exec.enable = true;

      programs.ghostty = {
        enable = true;
        clearDefaultKeybinds = true;

        settings = rec {
          font-family = my.theme.font.mono;
          font-size = 12;
          faint-opacity = 1;

          cursor-style = "block";
          cursor-style-blink = false;
          mouse-hide-while-typing = true;

          scrollback-limit = 1000;

          maximize = true;
          window-padding-x = 1;
          window-padding-y = window-padding-x;
          window-padding-balance = true;
          window-decoration = "none";
          window-show-tab-bar = "never";

          window-inherit-working-directory = true;
          shell-integration-features = [
            "title"
            "no-cursor"
            "no-sudo"
          ];

          keybind = [
            "ctrl+shift+c=copy_to_clipboard"
            "ctrl+shift+v=paste_from_clipboard"

            "ctrl+equal=increase_font_size:1"
            "ctrl+minus=decrease_font_size:1"
            "ctrl+0=reset_font_size"

            "alt+shift+p=toggle_command_palette"

            "alt+v=write_scrollback_file:open"

            "alt+t=new_tab"
            "alt+ctrl+t=toggle_tab_overview"
            "alt+shift+c=close_tab"
          ]
          ++ (builtins.map (index: "alt+${index}=goto_tab:${index}") (
            builtins.genList (x: builtins.toString (x + 1)) 9
          ));
        };
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
                program = cfg.args.run;
                args = [ config.my.programs.vcs.tui.command ];
              };
            }

            {
              key = "Y";
              mods = "Alt";
              command = {
                program = cfg.args.run;
                args = [ config.my.programs.file-manager.command ];
              };
            }
          ];
        };
      };
    })
  ];
}
