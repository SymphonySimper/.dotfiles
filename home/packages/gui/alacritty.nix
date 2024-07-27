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
    };
  };
}
