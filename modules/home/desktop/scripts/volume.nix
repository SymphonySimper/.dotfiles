{
  config,
  pkgs,
  lib,
  ...
}:
let
  volume = lib.getExe (
    pkgs.writeShellScriptBin "myvolume" # sh
      ''
        app="wpctl"

        #Icons
        sink="@DEFAULT_AUDIO_SINK@"
        source='@DEFAULT_AUDIO_SOURCE@'

        function get_mute() {
        	$app status $source | grep -qi -E "$1.*muted" && echo 0 || echo 1
        }

        get_volume() {
          volume=$($app get-volume $sink)
          volume="''${volume#*[[:space:]]}"

          if [[ $volume == 1.00 ]] || [[ $volume > 1.00 ]]; then
            echo "''${volume/.}"
          else
            echo "''${volume#0.}"
          fi
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
          if [[ $(get_mute $1) -eq 0 ]]; then
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
      ''
  );
in
{
  my.programs.desktop = {
    keybinds = [
      {
        mods = [ "super" ];
        key = "F2";
        command = "${volume} -d";
      }
      {
        mods = [ "super" ];
        key = "F3";
        command = "${volume} -u";
      }
      {
        mods = [
          "super"
          "shift"
        ];
        key = "F2";
        command = "${volume} -m";
      }
      {
        key = "F8";
        command = "${volume} -M"; # toggle mic
      }
    ];

    notifybar.modules =
      let
        cfg = config.my.programs.desktop.notifybar;
      in
      [
        {
          name = "Audio";
          order.module = "Caffeine";
          logic = # sh
            ''
              audio_mute=$(${volume} -gm)
              audio_volume=$(${volume} -gV)
              audio_title_style="${cfg.style.normal}"
              if [[ $audio_mute -eq 0 ]]; then
                audio="MUTED"
                audio_title_style="${cfg.style.bold}"
                audio_color="${cfg.color.err}"
              else
                audio="$audio_volume"
                if [[ $audio_volume -gt 80 ]]; then
                  audio_color="${cfg.color.err}"
                  audio_title_style="bold"
                elif [[ $audio_volume -gt 50 ]]; then
                  audio_color="${cfg.color.warn}"
                  audio_title_style="bold"
                elif [[ $audio_volume -gt 20 ]]; then
                  audio_color="${cfg.color.ok}"
                else
                  audio_color="${cfg.color.good}"
                fi
              fi
            '';
          style = "$audio_title_style";
          value = [
            {
              text = "\${audio}%";
              color = "$audio_color";
            }
          ];
        }

        {
          name = "Mic";
          order.module = "Audio";
          logic = # sh
            ''
              mic_mute=$(${volume} -gM)
              mic_title_style="${cfg.style.normal}"
              if [[ $mic_mute -eq 0 ]]; then
                mic="MUTED"
                mic_color="${cfg.color.good}"
              else
                mic="UNMUTED"
                mic_title_style="bold"
                mic_color="${cfg.color.err}"
              fi
            '';
          style = "$mic_title_style";
          value = [
            {
              text = "$mic";
              color = "$mic_color";
            }
          ];
        }
      ];
  };
}
