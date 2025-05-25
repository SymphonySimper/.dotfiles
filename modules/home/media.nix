{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.media;
in
{
  options.my.programs.media = {
    enable = lib.mkEnableOption "Media";
    image.enable = lib.mkEnableOption "Image";
    recorder.enable = lib.mkEnableOption "Recorder";
    video.enable = lib.mkEnableOption "Video";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        my.programs = {
          media = {
            image.enable = lib.mkDefault true;
            recorder.enable = lib.mkDefault false;
            video.enable = lib.mkDefault true;
          };

          desktop.keybinds =
            let
              playerctl = lib.getExe pkgs.playerctl;
            in
            builtins.concatMap
              (
                action:
                let
                  default = {
                    super = false;
                    cmd = "${playerctl} ${action.cmd}";
                  };
                in
                (
                  (builtins.map (key: default // { key = "XF86Audio${key}"; }) action.fn)
                  ++ [
                    (
                      default
                      // {
                        key = "F7";
                        mod = action.mod;
                      }
                    )
                  ]
                )
              )
              [
                {
                  cmd = "play-pause";
                  fn = [
                    "Play"
                    "Pause"
                  ];
                  mod = null;
                }
                {
                  cmd = "next";
                  fn = [ "Next" ];
                  mod = "SHIFT";
                }
                {
                  cmd = "previous";
                  fn = [ "Prev" ];
                  mod = "CTRL";
                }
              ];
        };
      }

      (lib.mkIf cfg.image.enable {
        home.packages = [ pkgs.loupe ];

        my.programs.desktop.mime."org.gnome.Loupe" = [
          "image/jpeg"
          "image/png"
        ];
      })

      (lib.mkIf cfg.recorder.enable {
        programs.obs-studio.enable = true;

        my.programs.desktop.windows = [
          {
            id = "com.obsproject.Studio";
            workspace = 9;
          }
        ];
      })

      (lib.mkIf cfg.video.enable {
        my.programs.desktop.windows = [
          {
            id = "mpv";
            workspace = 5;
            state = [
              "fullscreen"
              {
                name = "idleinhibit";
                opts = "focus";
              }
            ];
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
      })

      (lib.mkIf cfg.video.enable {
        programs = {
          yt-dlp.enable = true;
          mpv.config.script-opts = "ytdl_hook-ytdl_path=${lib.getExe config.programs.yt-dlp.package}";
        };
      })
    ]
  );
}
