{ userSettings, ... }:
let
  padding = 2;
in
{
  programs.alacritty = {
    enable = userSettings.programs.terminal == "alacritty";
    settings = {
      live_config_reload = false;
      cursor = {
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
          family = userSettings.font.mono;
          style = "Regular";
        };
        bold = {
          family = userSettings.font.mono;
          style = "Bold";
        };
        italic = {
          family = userSettings.font.mono;
          style = "Italic";
        };
        bold_italic = {
          family = userSettings.font.mono;
          style = "Bold Italic";
        };
      };

      window = {
        decorations = "none";
        opacity = 1;
        startup_mode = "Maximized";
        padding = {
          x = padding;
          y = padding;
        };
        dynamic_padding = true;
      };
    };
  };
}
