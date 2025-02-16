{
  pkgs,
  lib,
  my,
  ...
}:
{
  config = lib.mkIf my.gui.enable {
    programs.mpv = {
      enable = true;
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
        script-opts = "ytdl_hook-ytdl_path=${lib.getExe pkgs.yt-dlp}";

        background-color = "#000000";
      };
    };

    programs.yt-dlp.enable = true;
  };
}
