{ pkgs, lib, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "screenshot" ''
      take_screenshot() {
        current_date=$(date +%s)
        ${lib.getExe pkgs.sway-contrib.grimshot} --notify --cursor \
        savecopy $1 \
        "$HOME/Pictures/Screenshots/$current_date.png"
      }

      case "$1" in
      -r) take_screenshot area ;;
      -w) take_screenshot window ;;
      -s) take_screenshot output ;;
      esac
    '')
  ];
}
