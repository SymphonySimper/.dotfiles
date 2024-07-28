{ config, pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "brightness" ''
      app="${pkgs.brightnessctl}/bin/brightnessctl -m"
      backup_file="${config.xdg.cacheHome}/last-brightness"

      toggle_ness() {
      	if [ -f $backup_file ]; then
      		$app s $(cat $backup_file)
      		rm $backup_file
      	else
      		$app g >$backup_file
      		$app s 100%
      	fi

      }
      case "$1" in
      -u) $app s +2% ;;
      -d) $app s 2%- ;;
      -s) $app s $2 ;;
      -t) toggle_ness ;;
      esac
    ''
    )
  ];
}
