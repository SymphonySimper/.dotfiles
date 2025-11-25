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
      command = "kitty";
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
          ''${cfg.command} @ launch --cwd=current --type=tab "$@" > /dev/null 2>&1'';
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
              id = "kitty";
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

      programs.kitty = {
        enable = true;
        shellIntegration.mode = "no-prompt-mark no-cursor";

        font = {
          size = 12;
          name = my.theme.font.mono;
        };

        settings = {
          allow_remote_control = true;
          hide_window_decorations = true;
          scrollback_lines = 1000;
          mouse_hide_wait = -1;

          dim_opacity = 0.9;

          cursor_shape = "block";
          cursor_shape_unfocused = "hollow";
          cursor_blink_interval = 0;

          tab_bar_edge = "top";
          tab_bar_style = "separator";
          tab_separator = "''";
          tab_title_template = "' [{index}] {title} '";
          tab_bar_background = my.theme.color.crust;
          inactive_tab_background = my.theme.color.surface0;

          # performance
          repaint_delay = 2; # ms
          input_delay = 2; # ms
          sync_to_monitor = false;
          wayland_enable_ime = false;

          clear_all_shortcuts = true;
        };

        actionAliases = {
          "launch_tab" = "launch --cwd=current --type=tab";
        };

        keybindings = {
          "ctrl+shift+c" = "copy_to_clipboard";
          "ctrl+shift+v" = "paste_from_clipboard";

          "ctrl+shift+equal" = "change_font_size all +2.0";
          "ctrl+shift+plus" = "change_font_size all +2.0";

          "alt+t" = "launch_tab";
          "alt+shift+c" = "close_tab";

          "alt+v" = "launch_tab --stdin-source=@screen_scrollback ${config.my.programs.editor.command}";
          "alt+shift+v" = "open_url_with_hints";

          # external programs
          "alt+g" = "launch_tab ${config.my.programs.vcs.tui.command}";
          "alt+y" = "launch_tab ${config.my.programs.file-manager.command}";
        }
        // (builtins.listToAttrs (
          builtins.map (index: {
            name = "alt+${index}";
            value = "goto_tab ${index}";
          }) (builtins.genList (x: builtins.toString (x + 1)) 9)
        ));
      };
    })
  ];
}
