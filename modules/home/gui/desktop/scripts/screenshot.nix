{ pkgs, lib, ... }:
# sh
''
  take_screenshot() {
    current_date=$(date +%s)
    ${lib.getExe pkgs.grimblast} --notify --cursor \
    copysave $1 \
    "$HOME/Pictures/Screenshots/$current_date.png"
  }

  case "$1" in
  -r) take_screenshot area ;;
  -w) take_screenshot active ;;
  -s) take_screenshot output ;;
  esac
''
