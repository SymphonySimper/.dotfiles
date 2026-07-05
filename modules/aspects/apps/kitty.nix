{ lib, ... }: {
  den.aspects.apps.kitty = {
    homeManager =
      { config, ... }:
      {
        desktop.gnome.keybinds = [
          {
            mods = [ "super" ];
            key = "t";
            command = lib.getExe config.programs.kitty.package;
          }
        ];

        xdg = {
          terminal-exec = {
            enable = true;
            settings.default = [ "kitty.desktop" ];
          };
        };

        programs.tmux.terminal = "kitty";

        programs.kitty = {
          enable = true;
          shellIntegration.mode = "no-prompt-mark no-cursor";

          font = {
            size = 12;
            name = config.theme.fonts.mono.name;
          };

          settings = {
            allow_remote_control = false;
            hide_window_decorations = true;
            scrollback_lines = 1000;
            mouse_hide_wait = -1;
            enabled_layouts = "splits,stack";

            dim_opacity = 0.9;
            disable_ligatures = "always";

            cursor_shape = "block";
            cursor_shape_unfocused = "hollow";
            cursor_blink_interval = 0;

            tab_bar_edge = "top";
            tab_bar_style = "separator";
            tab_separator = "''";
            tab_title_template = "' [{index}] {title} '";
            tab_bar_background = config.theme.color.crust.hex;
            inactive_tab_background = config.theme.color.surface0.hex;

            # performance
            wayland_enable_ime = false;

            clear_all_shortcuts = true;
          };

          keybindings =
            let
              launchCurr = "launch --cwd=current";
              launchCurrTab = "${launchCurr} --type=tab";
            in
            {
              "ctrl+shift+c" = "copy_to_clipboard";
              "ctrl+shift+v" = "paste_from_clipboard";

              "ctrl+shift+equal" = "change_font_size all +2.0";
              "ctrl+shift+plus" = "change_font_size all +2.0";

              "alt+v" = "${launchCurrTab} --stdin-source=@screen_scrollback $EDITOR";
              "alt+shift+v" = "open_url_with_hints";

              "alt+t" = "${launchCurrTab}";
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

              "alt+=" = "${launchCurr} --location=vsplit";
              "alt++" = "${launchCurr} --location=hsplit";
              "alt+shift+w" = "close_window";
              "alt+m" = "toggle_layout stack"; # workaround for pane zoom
              ## focus
              "alt+h" = "neighboring_window left";
              "alt+j" = "neighboring_window down";
              "alt+k" = "neighboring_window up";
              "alt+l" = "neighboring_window right";
              ## resize
              "alt+shift+h" = "resize_window wider";
              "alt+shift+j" = "resize_window shorter";
              "alt+shift+k" = "resize_window taller";
              "alt+shift+l" = "resize_window narrower";
              "alt+shift+r" = "resize_window reset";
              ## move
              "alt+ctrl+h" = "move_window left";
              "alt+ctrl+j" = "move_window down";
              "alt+ctrl+k" = "move_window up";
              "alt+ctrl+l" = "move_window right";
            };
        };
      };
  };
}
