{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "brightness" ''
      app_bin="${pkgs.brightnessctl}/bin/brightnessctl"
      app="$app_bin -m"
      backup_file="${config.xdg.cacheHome}/last-brightness"
      save_file="${config.xdg.dataHome}/.my-brightness"

      toggle_ness() {
      	if [ -f $backup_file ]; then
      		$app s $(cat $backup_file)
      		rm $backup_file
      	else
      		$app g >$backup_file
      		$app s 100%
      	fi
      }

      save() {
        echo $($app_bin g) > $save_file;
      }

      restore() {
        if [ -f "$save_file" ]; then
          $app s $(cat $save_file)
        fi
      }

      case "$1" in
      -u) $app s +2% ;;
      -d) $app s 2%- ;;
      -s) $app s $2 ;;
      -t) toggle_ness ;;
      -r) restore ;; # Restore brightness
      esac

      save
    '')
  ];
}
