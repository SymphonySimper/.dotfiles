{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.video;
in
{
  options.my.programs.video = {
    enable = lib.mkEnableOption "Video";
    recorder.enable = lib.mkEnableOption "Recorder";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        my.desktop.windows = [
          {
            id = "mpv";
            workspace = 5;
          }
        ];

        catppuccin.mpv.enable = false;
        programs.mpv = {
          enable = true;

          package = (
            pkgs.mpv-unwrapped.wrapper {
              mpv = pkgs.mpv-unwrapped.override {
                ffmpeg = pkgs.ffmpeg-full;
                waylandSupport = true;
              };
            }
          );

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
            osd-font = my.theme.font.sans;

            # Subtitles
            sub-visibility = "yes";
            sub-auto = "fuzzy"; # external subs don't have to match the file name exactly to autoload
            sub-file-paths-append = [
              "ass" # search for external subs in these relative subdirectories
              "srt"
              "sub"
              "subs"
              "subtitles"
            ];

            sub-font = my.theme.font.sans;
            sub-font-size = 48;
            sub-border-size = 2.0;

            # Hardware acceleration
            hwdec = "auto-safe";
            vo = "gpu";
            profile = "gpu-hq";
            gpu-context = "wayland";

            # Audio
            audio-file-auto = "fuzzy"; # external audio doesn't has to match the file name exactly to autoload
            audio-pitch-correction = "yes"; # automatically insert scaletempo when playing with higher speed

            # Border
            border = "no";

            background-color = "#000000";
          };
        };
      }

      {
        programs = {
          yt-dlp.enable = true;
          mpv.config.script-opts = "ytdl_hook-ytdl_path=${lib.getExe config.programs.yt-dlp.package}";
        };
      }

      (lib.mkIf cfg.recorder.enable {
        programs.obs-studio.enable = true;
        my.desktop.windows = [
          {
            id = "com.obsproject.Studio";
            workspace = 9;
          }
        ];
      })
    ]
  );
}
