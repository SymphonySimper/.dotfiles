{ userSettings, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "${userSettings.font.mono}:size=8";
        dpi-aware = "yes";
        pad = "8x8";
      };
    };
  };
}
