{
  my,
  pkgs,
  lib,
  ...
}:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
      {
        event = "lock";
        command = "lock";
      }
    ];
    timeouts = [
      {
        timeout = 60;
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
      {
        timeout = 90;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  home.packages = [
    (pkgs.writeShellScriptBin "mycaffiene" ''
      handle_idle() {
        systemctl $1 --user swayidle;
      }

      noti() {
        ${lib.my.mkNotification {
          tag = "mycaffiene";
          title = "Caffiene $1";
        }}
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

  catppuccin.swaylock.flavor = my.theme.flavors.dark;
  programs.swaylock.enable = true;
}
