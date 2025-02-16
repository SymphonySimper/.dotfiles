{
  config,
  pkgs,
  lib,
  ...
}:
# sh
''
  app_bin="${lib.getExe pkgs.brightnessctl}"
  app="$app_bin -m"
  backup_file="${config.xdg.cacheHome}/last-brightness"
  save_file="${config.xdg.dataHome}/.my-brightness"

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
