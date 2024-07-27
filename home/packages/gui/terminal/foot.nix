{ userSettings, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = userSettings.font.mono;
        dpi-aware = "yes";
      };
    };
  };
}
