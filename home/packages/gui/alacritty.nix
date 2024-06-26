{ ... }:
let
  font = "JetBrainsMono Nerd Font";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = false;
      cursor =
        {
          vi_mode_style = "Block";
          style = {

            blinking = "off";
            shape = "Block";
          };
        };
      env = {
        TERM = "xterm-256color";
      };

      font = {
        size = 12;
        normal = {
          family = font;
          style = "Regular";
        };
        bold = {
          family = font;
          style = "Bold";
        };
        italic = {
          family = font;
          style = "Italic";
        };
        bold_italic = {
          family = font;
          style = "Bold Italic";
        };
      };

      window = {
        decorations = "none";
        opacity = 1;
        startup_mode = "Maximized";
        padding = {
          x = 8;
          y = 8;
        };
      };

      colors = {
        primary = {

          background = "#1E1E2E";
          foreground = "#CDD6F4";
          dim_foreground = "#CDD6F4";
          bright_foreground = "#CDD6F4";
        };

        cursor =
          {
            text = "#1E1E2E";
            cursor = "#F5E0DC";
          };

        vi_mode_cursor = {
          text = "#1E1E2E";
          cursor = "#B4BEFE";
        };


        search = {
          matches =
            {
              foreground = "#1E1E2E";
              background = "#A6ADC8";
            };


          focused_match =
            {
              foreground = "#1E1E2E";
              background = "#A6E3A1";
            };

        };


        footer_bar =
          {
            foreground = "#1E1E2E";
            background = "#A6ADC8";
          };

        hints = {
          start =
            {
              foreground = "#1E1E2E";
              background = "#F9E2AF";
            };

          end =
            {
              foreground = "#1E1E2E";
              background = "#A6ADC8";
            };
        };


        selection =
          {
            text = "#1E1E2E";
            background = "#F5E0DC";
          };

        normal =
          {
            black = "#45475A";
            red = "#F38BA8";
            green = "#A6E3A1";
            yellow = "#F9E2AF";
            blue = "#89B4FA";
            magenta = "#F5C2E7";
            cyan = "#94E2D5";
            white = "#BAC2DE";
          };

        bright =
          {
            black = "#585B70";
            red = "#F38BA8";
            green = "#A6E3A1";
            yellow = "#F9E2AF";
            blue = "#89B4FA";
            magenta = "#F5C2E7";
            cyan = "#94E2D5";
            white = "#A6ADC8";
          };

        dim =
          {
            black = "#45475A";
            red = "#F38BA8";
            green = "#A6E3A1";
            yellow = "#F9E2AF";
            blue = "#89B4FA";
            magenta = "#F5C2E7";
            cyan = "#94E2D5";
            white = "#BAC2DE";
          };

        indexed_colors = [
          {
            index = 16;
            color = "#FAB387";
          }
          {
            index = 17;
            color = "#F5E0DC";
          }
        ];
      };
    };
  };
}
