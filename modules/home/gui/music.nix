{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.music;

  id = "Music";
  app = pkgs.spotify;
  status_file = "/tmp/my-music-status";

  script =
    pkgs.writeShellScriptBin "my${id}" # sh
      ''
        cmd="${lib.getExe' pkgs.playerctl "playerctl"} -p spotify"

        function open_play_pause() {
        	if ! $cmd status; then
        	  ${lib.strings.optionalString my.gui.desktop.enable config.my.desktop.uwsm} ${lib.getExe' app "spotify"} 2>&1 /dev/null &
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
{
  options.my.programs.music.enable = lib.mkEnableOption "${id}";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = lib.optionals (!my.gui.desktop.enable) [
          app
          script
        ];

        my.desktop = {
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
  );
}
