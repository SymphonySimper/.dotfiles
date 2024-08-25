{ pkgs, userSettings, ... }:
let
  enable = userSettings.programs.video == "mpv";
in
{
  programs.mpv = {
    inherit enable;
    catppuccin.enable = false;
    bindings = {
      "Alt+LEFT" = "script-message Cycle_Video_Rotate -90";
      "Alt+RIGHT" = "script-message Cycle_Video_Rotate 90";
    };
    config = {
      fullscreen = "yes";

      # OSD / OSC
      osc = "no";
      osd-font-size = 32;
      osd-border-size = 1.5;
      osd-font = "Poppins";

      # Subtitles
      sub-visibility = "no";
      sub-auto = "fuzzy"; # external subs don't have to match the file name exactly to autoload
      sub-file-paths-append = [
        "ass" # search for external subs in these relative subdirectories
        "srt"
        "sub"
        "subs"
        "subtitles"
      ];

      sub-font = "Poppins";
      sub-font-size = 48;
      sub-border-size = 2.0;

      # Audio
      audio-file-auto = "fuzzy"; # external audio doesn't has to match the file name exactly to autoload
      audio-pitch-correction = "yes"; # automatically insert scaletempo when playing with higher speed

      # Border
      border = "no";
      script-opts = "ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp";

      background-color = "#000000";
    };
  };

  programs.yt-dlp = {
    inherit enable;
  };
}
