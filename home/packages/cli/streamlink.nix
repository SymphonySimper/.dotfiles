{
  pkgs,
  lib,
  profileSettings,
  ...
}:
{
  config = lib.mkIf (profileSettings.profile == "gui") {
    home.packages = [
      pkgs.streamlink
    ];

    xdg.configFile = {
      "streamlink/config".text = ''
        player=${lib.getExe pkgs.mpv}
        default-stream=1080p,720p,480p,best
      '';
    };
  };
}
