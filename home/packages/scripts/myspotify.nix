{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "myspotify" # bash
      ''
        cmd="${pkgs.playerctl}/bin/playerctl -p spotify"
        icon=""

        # status() {
        # 	text=$icon
        # 	class=""
        # 	tooltip=""
        #
        # 	current_status="$($cmd status)"
        # 	case "$current_status" in
        # 	'Playing')
        # 		class='playing'
        # 		song_title="$($cmd metadata title)"
        # 		song_artist="$($cmd metadata artist)"
        # 		tooltip="$song_title [$song_artist]"
        # 		;;
        # 	'Paused')
        # 		class='paused'
        # 		tooltip="Paused"
        # 		;;
        # 	*)
        # 		class='disabled'
        # 		tooltip="Click to open spotify"
        # 		;;
        # 	esac
        #
        # 	printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$class" "$tooltip"
        # }

        open_play_pause() {
        	if ! $cmd status; then
        		spotify-launcher 2>&1 /dev/null &
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

        case "$1" in
        o) open_play_pause ;;
        q) killall spotify ;;
        n) change_song n ;;
        p) change_song p ;;
        esac

        # status
      ''
    )
  ];
}
