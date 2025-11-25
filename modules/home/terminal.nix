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

  keys = {
    alt = "alt";
    ctrl = "ctrl";
    shift = "shift";
  };
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
          scrollback_lines = 1000;
          hide_window_decorations = true;
          allow_remote_control = true;

          mouse_hide_wait = 0;

          cursor_shape = "block";
          cursor_shape_unfocused = "hollow";
          cursor_blink_interval = 0;

          tab_bar_edge = "top";
          tab_bar_style = "separator";
          tab_separator = "''";
          tab_title_template = "' [{index}] {title} '";
          tab_bar_background = my.theme.color.crust;
          inactive_tab_background = my.theme.color.surface0;

          clear_all_shortcuts = true;
        };

        actionAliases = {
          "launch_tab" = "launch --cwd=current --type=tab";
        };

        keybindings = {
          "${keys.ctrl}+${keys.shift}+c" = "copy_to_clipboard";
          "${keys.ctrl}+${keys.shift}+v" = "paste_from_clipboard";

          "${keys.ctrl}+${keys.shift}+equal" = "change_font_size all +2.0";
          "${keys.ctrl}+${keys.shift}+plus" = "change_font_size all +2.0";

          "${keys.alt}+t" = "launch_tab";
          "${keys.alt}+${keys.shift}+c" = "close_tab";

          "${keys.alt}+v" =
            "launch_tab --stdin-source=@screen_scrollback ${config.my.programs.editor.command}";
          "${keys.alt}+${keys.shift}+v" = "open_url_with_hints";

          # external programs
          "${keys.alt}+g" = "launch_tab ${config.my.programs.vcs.tui.command}";
          "${keys.alt}+y" = "launch_tab ${config.my.programs.file-manager.command}";
        }
        // (builtins.listToAttrs (
          builtins.map (
            i:
            let
              index = builtins.toString i;
            in
            {
              name = "${keys.alt}+${index}";
              value = "goto_tab ${index}";
            }
          ) (builtins.genList (x: x + 1) 9)
        ));
      };
    })
  ];
}
