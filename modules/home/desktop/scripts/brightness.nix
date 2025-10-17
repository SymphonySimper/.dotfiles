{
  config,
  pkgs,
  lib,
  ...
}:
let
  brightness = lib.getExe (
    pkgs.writeShellScriptBin "mybrightness" # sh
      ''
        app_bin="${lib.getExe pkgs.brightnessctl}"
        app="$app_bin -m"
        backup_file="${config.xdg.cacheHome}/last-brightness"
        save_file="${config.xdg.stateHome}/.my-brightness"

        toggle_ness() {
        	if [ -f $backup_file ]; then
        		$app s $(<$backup_file)
        		rm $backup_file
        	else
        		$app g >$backup_file
        		$app s 100%
        	fi
        }

        set_brightness() {
          $app s $1;
          save;
        }

        get_brightness() {
          echo "$($app i | cut -d ',' -f4 | tr -d '%')"
        }

        save() {
          echo $($app_bin g) > $save_file;
          value=$(get_brightness)
          ${lib.my.mkNotification {
            tag = "my-brightness";
            title = "Brightness ($value%)";
            progress = "$value";
          }}
        }

        restore() {
          sleep 0.2s
          if [ -f "$save_file" ]; then
            $app s $(<$save_file)
            return 0;
          fi

          return 1;
        }

        case "$1" in
        -u) set_brightness +2% ;;
        -d) set_brightness 2%- ;;
        -s) set_brightness $2 ;;
        -g) get_brightness ;;
        -t) toggle_ness ;;
        -r) restore ;; # Restore brightness
        esac
      ''
  );
in
{
  my.programs.desktop = {
    keybinds = [
      {
        key = "F5";
        command = "${brightness} -d";
      }
      {
        key = "F6";
        command = "${brightness} -u";
      }
    ];

    notifybar.modules =
      let
        cfg = config.my.programs.desktop.notifybar;
      in
      [
        {
          name = "Brightness";
          order.module = "Refresh Rate";
          logic = # sh
            ''
              brightness_status=$(${brightness} -g)
              brightness_title_style="${cfg.style.normal}"
              if [[ $brightness_status -gt 80 ]]; then
                brightness_color="${cfg.color.err}"
                brightness_title_style="bold"
              elif [[ $brightness_status -gt 50 ]]; then
                brightness_color="${cfg.color.warn}"
                brightness_title_style="bold"
              elif [[ $brightness_status -gt 20 ]]; then
                brightness_color="${cfg.color.ok}"
              else
                brightness_color="${cfg.color.good}"
              fi
            '';
          style = "$brightness_title_style";
          value = [
            {
              text = "\${brightness_status}%";
              color = "$brightness_color";
            }
          ];
        }
      ];
  };
}
