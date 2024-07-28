{ userSettings, ... }:
let
  enable = if userSettings.programs.terminal == "foot" then true else false;
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
