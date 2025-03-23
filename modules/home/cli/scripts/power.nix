{ pkgs, lib, ... }:
# bash
''
  action=""
  case "$1" in
    off) action="poweroff" ;;
    re|reboot) action="reboot" ;;
  esac

  if [[ -z "$action" ]]; then
    exit 1
  fi

  # kill chromium gracefully
  browsers=('chrome' 'chromium' 'brave')
  for browser in "''${browsers[@]}"; do
    if [[ -n "$(${lib.getExe' pkgs.toybox "pgrep"} $browser)" ]]; then
      ${lib.getExe pkgs.killall} "$browser" --wait
    fi
  done

  eval "$action"
''
