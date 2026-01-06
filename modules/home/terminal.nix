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
  options.my.programs.terminal = {
    shell = lib.mkOption {
      type = lib.types.submodule {
        options = {
          command = lib.mkOption {
            description = "Command to run on launch";
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
        command = config.my.programs.shell.nu.command;
        args = [ ];
      };
    };
  }
  // (lib.my.mkCommandOption {
    category = "Terminal";
    command = "kitty";
    args = {
      command = "-e";
    };
  });

  config = lib.mkIf my.gui.enable {
    my.programs = {
      desktop = {
        keybinds = [
          {
            mods = [ "super" ];
            key = "t";
            command = cfg.command;
          }
        ];
      };
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };

    programs.kitty = {
      enable = true;
      shellIntegration.mode = "no-prompt-mark no-cursor";

      font = {
        size = 12;
        name = my.theme.font.mono;
      };

      settings = {
        shell = builtins.concatStringsSep " " ([ cfg.shell.command ] ++ cfg.shell.args);

        allow_remote_control = false;
        hide_window_decorations = true;
        scrollback_lines = 1000;
        mouse_hide_wait = -1;

        dim_opacity = 0.9;
        disable_ligatures = "always";

        cursor_shape = "block";
        cursor_shape_unfocused = "hollow";
        cursor_blink_interval = 0;

        tab_bar_edge = "top";
        tab_bar_style = "separator";
        tab_separator = "''";
        tab_title_template = "' [{index}] {title} '";
        tab_bar_background = my.theme.color.crust.hex;
        inactive_tab_background = my.theme.color.surface0.hex;

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

        "alt+v" = "launch_tab --stdin-source=@screen_scrollback ${config.my.programs.editor.command}";
        "alt+shift+v" = "open_url_with_hints";

        "alt+t" = "launch --cwd=current --type=tab";
        "alt+shift+c" = "close_tab";
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
      };
    };
  };
}
