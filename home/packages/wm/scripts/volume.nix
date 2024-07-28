{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin
      "volume"
      /*bash*/
      ''
        app="${pkgs.wireplumber}/bin/wpctl"

        #Icons
        sink="@DEFAULT_AUDIO_SINK@"
        source='@DEFAULT_AUDIO_SOURCE@'

        function get_mute() {
        	$app status "$1" | grep -qi muted && echo 0 || echo 1
        }

        get_vol() { $app get-volume $sink; }

        change_vol() { $app set-volume $sink "$1"; }

        set_vol() { change_vol "$1"; }

        toggle_mute() { $app set-mute $sink toggle; }

        toggle_mic() {
        	$app set-mute $source toggle
        	pkill -SIGRTMIN+8 waybar
        }

        case "$1" in
        -s)
        	shift
        	set_vol "$1"
        	;;
        -u) change_vol "0.02+" ;;
        -d) change_vol "0.02-" ;;
        -U) change_vol "0.1+" ;;
        -D) change_vol "0.1-" ;;
        -m) toggle_mute ;;
        -M) toggle_mic ;;
        -gM) get_mute $source ;;
        esac
      '')
  ];
}
