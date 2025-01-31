{ pkgs, lib, ... }:
# sh
''
  case "$1" in
    get) nmcli -p -g type connection show --active | head -n1 | cut -d '-' -f3 ;;
    reload) sudo systemctl restart NetworkManager &&  ${
      lib.my.mkNotification { title = "Restarted network manager"; }
    } ;;
  esac
''
