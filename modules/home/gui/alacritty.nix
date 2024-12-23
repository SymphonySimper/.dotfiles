{ lib, my, ... }:
let
  padding = 1;
in
{
  config = lib.mkIf my.gui.enable {
    programs.alacritty = {
      enable = my.programs.terminal == "alacritty";
      settings = {
        general.live_config_reload = false;
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
  };
}
