{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "caffiene" ''
      handle_idle() {
        systemctl $1 --user swayidle;
      }

      noti() {
        notify replace "my-caffiene" "Caffiene $1"
      }

      get_status() {
        handle_idle status | grep -q 'inactive' && echo 0 || echo 1
      }

      case "$1" in
        -g) get_status ;;
         *)
          is_inactive=$(get_status)
          if [ $is_inactive -eq 0 ]; then
            handle_idle start
            noti "Disabled"
          else
            handle_idle stop
            noti "Enabled"
          fi
          ;;
      esac
    '')
  ];
}
