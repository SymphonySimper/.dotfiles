{
  my,
  pkgs,
  lib,
  ...
}:
let
  dunstctl = lib.getExe' pkgs.dunst "dunstctl";
  id = "mydunst";
in
{
  services.dunst = {
    enable = if my.programs.notification == "dunst" then true else false;
    settings.global = {
      font = "${my.theme.font.sans} 12";
      origin = "top-right";
      offset = "8x8";
      frame_width = "1";
      corner_radius = "8";
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin id # sh
      ''
        function notify() {
          ${lib.my.mkNotification {
            title = "$1";
            body = "$2";
            tag = id;
          }}
        }

        case "$1" in
          t|toggle)
            curr_status="Unpaused"
            msg=""
            if [[ "$(${dunstctl} is-paused)" != "true" ]]; then
              curr_status="Paused"
              msg="Will be $curr_status in 5s"
            fi

            notify "Notfications $curr_status"  "$msg"
            if [[ -n "$msg" ]]; then
              sleep 5s
            fi
            ${dunstctl} set-paused toggle
          ;;
          action) ${dunstctl} action ;;
          close) ${dunstctl} close ;;
          history) ${dunstctl} history-pop ;;
        esac
      ''
    )
  ];
}
