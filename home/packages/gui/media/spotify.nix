{ pkgs, lib, ... }:
let
  mySpotifyScript =
    pkgs.writeShellScriptBin "my-spotify" # bash
      ''
        cmd="${pkgs.playerctl}/bin/playerctl -p spotify"

        open_play_pause() {
        	if ! $cmd status; then
        		spotify 2>&1 /dev/null &
        		sleep 1.5s
        	fi
        	$cmd play-pause
        }

        change_song() {
        	case "$1" in
        	n) $cmd next ;;
        	p) $cmd previous ;;
        	esac
        }

        get_volume() {
          echo $($cmd volume)
        }

        set_volume() {
          curr_volume=$(get_volume)
          volume_inc=0.02
          case "$1" in
          inc) volume_type="+" ;;
          dec) volume_type="-" ;;
          esac
          volume_to_set=$(echo "$curr_volume $volume_type $volume_inc" | ${pkgs.bc}/bin/bc -l)
          $cmd volume $volume_to_set;
          volume_progress=$(echo "($(get_volume) * 100) / 1" | ${pkgs.bc}/bin/bc)
          ${
            lib.my.mkNotification {
              tag = "my-spotify";
              title = "Spotify Volume ($volume_progress%)";
              progress = "$volume_progress";
            }
          }
        }

        case "$1" in
        o) open_play_pause ;;
        q) killall spotify ;;
        n) change_song n ;;
        p) change_song p ;;
        u) set_volume inc ;;
        d) set_volume dec ;;
        status)
          current_status="$($cmd status)"
          echo "''${current_status,,}"
          ;;
        esac
      '';
in
{
  home.packages = with pkgs; [
    spotify
    (mySpotifyScript)
  ];
}
// lib.my.mkSystemdTimer rec {
  name = "my-kill-spotify";
  desc = "Kill spotify when inactive";
  time = "1m";
  ExecStart = lib.getExe (
    pkgs.writeShellScriptBin "${name}" ''
      app=".spotify-wrappe"
      my_script="${lib.getExe (mySpotifyScript)}"

      if ${pkgs.procps}/bin/pgrep "$app" > /dev/null; then
        if [[ "$($my_script status)" != "playing" ]]; then
          ${pkgs.procps}/bin/pkill "$app" > /dev/null
          ${
            lib.my.mkNotification {
              title = "Bye Spotify";
              body = "Killed Spotify due to inactivity.";
              tag = name;
              urgency = "normal";
            }
          }
        fi
      fi
    ''
  );
}
