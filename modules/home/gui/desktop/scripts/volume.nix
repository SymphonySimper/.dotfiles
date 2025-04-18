{ pkgs, lib, ... }:
let
  volume =
    pkgs.writeShellScriptBin "myvolume" # sh
      ''
        app="${lib.getExe' pkgs.wireplumber "wpctl"}"

        #Icons
        sink="@DEFAULT_AUDIO_SINK@"
        source='@DEFAULT_AUDIO_SOURCE@'

        function get_mute() {
        	$app status $source | grep -qi -E "$1.*muted" && echo 0 || echo 1
        }

        get_volume() {
          volume=$($app get-volume $sink | cut -d ' ' -f2)
          echo $(echo "$volume * 100 / 1" | "${lib.getExe' pkgs.bc "bc"}")
        }

        change_vol() {
          $app set-volume $sink "$1";
          volume=$(get_volume)
          ${lib.my.mkNotification {
            tag = "my-audio";
            title = "Volume ($volume%)";
            progress = "$volume";
          }}
        }

        set_vol() { change_vol "$1"; }

        notify_toggle() {
          if [ $(get_mute $1) -eq 0 ]; then
            status="muted"
          else
            status="unmuted"
          fi
          ${lib.my.mkNotification {
            tag = "my-$1";
            title = "$2 is $status";
          }}
        }

        toggle_mute() {
          $app set-mute $sink toggle;
          notify_toggle "stereo" "Audio"
        }

        toggle_mic() {
        	$app set-mute $source toggle
          notify_toggle "mic" "Mic"
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
        -gV)
          # Get audio volume
          get_volume
          ;;
        # Get audio mute
        -gm) get_mute "stereo" ;;
        # Get mic mute
        -gM) get_mute "mic" ;;
        esac
      '';
in
{
  home.packages = [ volume ];

  my.desktop.keybinds = [
    {
      key = "F2";
      cmd = "${lib.getExe volume} -d";
    }
    {
      key = "F3";
      cmd = "${lib.getExe volume} -u";
    }
    {
      mod = "SHIFT";
      key = "F2";
      cmd = "${lib.getExe volume} -m";
    }
    {
      super = false;
      key = "F8";
      cmd = "${lib.getExe volume} -M"; # toggle mic
    }
  ];
}
