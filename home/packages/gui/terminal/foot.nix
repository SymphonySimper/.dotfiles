{ userSettings, ... }:
let
  enable = userSettings.programs.terminal == "foot";
in
{
  programs.foot = {
    inherit enable;
    server.enable = enable;
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
