{ config, ... }:
let
  padding = 1;
in
{
  programs.alacritty = {
    enable = config.my.program.terminal == "alacritty";
    settings = {
      live_config_reload = false;
      cursor = {
        vi_mode_style = "Block";
        style = {

          blinking = "off";
          shape = "Block";
        };
      };

      font = {
        size = 12;
        normal = {
          family = config.my.theme.font.mono.name;
          style = "Regular";
        };
        bold = {
          family = config.my.theme.font.mono.name;
          style = "Bold";
        };
        italic = {
          family = config.my.theme.font.mono.name;
          style = "Italic";
        };
        bold_italic = {
          family = config.my.theme.font.mono.name;
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
