{ my, config, ... }:
let
  padding = 2;
  desktopFile = "Alacritty.desktop";
in
{
  my.desktop = {
    autostart = [
      "${config.programs.alacritty.package}/share/applications/${desktopFile}"
    ];

    automove = [
      [
        desktopFile
        1
      ]
    ];
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
        padding = {
          x = padding;
          y = padding;
        };
        dynamic_padding = true;
      };

      scrolling.history = 0;

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

      cursor = {
        vi_mode_style = "Block";
        style = {
          blinking = "off";
          shape = "Block";
        };
      };

      mouse.hide_when_typing = true;

      # disable hints
      hints.enabled = [ ];
    };
  };
}
