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
    music.enable = lib.mkEnableOption "Music";
    recorder.enable = lib.mkEnableOption "Recorder";
    video.enable = lib.mkEnableOption "Video";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        my.programs.media = {
          image.enable = lib.mkDefault true;
          music.enable = lib.mkDefault true;
          recorder.enable = lib.mkDefault false;
          video.enable = lib.mkDefault true;
        };
      }

      (lib.mkIf cfg.image.enable {
        home.packages = [ pkgs.loupe ];

        my.programs.desktop.mime."org.gnome.Loupe" = [
          "image/jpeg"
          "image/png"
        ];
      })

      (lib.mkIf cfg.music.enable (
        let
          id = "Music";
          app = pkgs.spotify;
          status_file = "/tmp/my-music-status";

          script =
            pkgs.writeShellScriptBin "my${id}" # sh
              ''
                cmd="${lib.getExe' pkgs.playerctl "playerctl"} -p spotify"

                function open_play_pause() {
                	if ! $cmd status; then
                	  ${lib.strings.optionalString config.my.programs.desktop.enable config.my.programs.desktop.uwsm} ${lib.getExe' app "spotify"} 2>&1 /dev/null &
                		sleep 1.5s
                	fi
                	$cmd play-pause
                }

                function get_volume() { $cmd volume; }

                function set_volume() {
                  curr_volume=$(get_volume)

                  volume_inc=0.02
                  case "$1" in
                  inc) volume_type="+" ;;
                  dec) volume_type="-" ;;
                  esac

                  volume_to_set=$(echo "$curr_volume $volume_type $volume_inc" | ${lib.getExe' pkgs.bc "bc"} -l)
                  $cmd volume $volume_to_set;

                  volume_progress=$(echo "($(get_volume) * 100) / 1" | ${lib.getExe' pkgs.bc "bc"})
                  ${lib.my.mkNotification {
                    tag = "my${id}";
                    title = "${id} Volume ($volume_progress%)";
                    progress = "$volume_progress";
                  }}
                }

                function get_status() {
                  current_status="$($cmd status)"
                  echo "''${current_status,,}"
                }

                case "$1" in
                open_play_pause)
                  open_play_pause
                  sleep 0.5s
                  get_status > ${status_file}
                  ;;
                next) $cmd next ;;
                prev) $cmd previous ;;
                up) set_volume inc ;;
                down) set_volume dec ;;
                status) get_status ;;
                esac
              '';

          exe = lib.getExe script;
        in
        lib.mkMerge [
          {
            home.packages = lib.optionals (!my.gui.desktop.enable) [
              app
              script
            ];

            my.programs.desktop = {
              windows = [
                {
                  id = "Spotify.*";
                  type = "title";
                  silent = true;
                  workspace = 10;
                }
              ];

              keybinds = builtins.map (bind: bind // { cmd = "${exe} ${bind.cmd}"; }) [
                {
                  key = "F7";
                  cmd = "open_play_pause";
                  super = false;
                }
                {
                  mod = "CTRL";
                  key = "F7";
                  cmd = "prev";
                  super = false;
                }
                {
                  mod = "SHIFT";
                  key = "F7";
                  cmd = "next";
                  super = false;
                }
                {
                  mod = "SHIFT";
                  key = "F7";
                  cmd = "up";
                }
                {
                  key = "F7";
                  cmd = "down";
                }
              ];
            };
          }

          (
            let
              date = lib.getExe' pkgs.coreutils "date";
              waitTime = 10;
            in
            (lib.my.mkSystemdTimer rec {
              name = "my-kill-${id}";
              desc = "Kill ${id} when inactive";
              time = "${builtins.toString (waitTime / 2)}m";
              ExecStart = lib.getExe (
                pkgs.writeShellScriptBin "${name}" ''
                  app='.spotify-wrappe'
                  status='paused'

                  if [[ ! -f ${status_file} ]]; then
                    ${exe} status > "${status_file}"
                    exit 0
                  fi

                  time_diff=$(($(${date} +%s) - $(${date} -r ${status_file} +%s)))
                  if [[ $time_diff -lt ${builtins.toString (waitTime * 60)} ]]; then
                    exit 0
                  fi

                  prev_status="$(<${status_file})"
                  curr_status="$(${exe} status)"
                  if [[ "$curr_status" == "$status" ]] && [[ "$prev_status" == "$status" ]]; then
                    ${lib.getExe' pkgs.procps "pkill"} "$app" > /dev/null
                    ${lib.my.mkNotification {
                      title = "Bye ${id}";
                      body = "Killed ${id} due to inactivity.";
                      tag = name;
                      urgency = "normal";
                    }}
                  else
                    echo "$curr_status" > "${status_file}"
                  fi
                ''
              );
            })
          )
        ]
      ))

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
