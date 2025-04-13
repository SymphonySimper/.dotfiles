{
  my,
  pkgs,
  lib,
  ...
}:
let
  dunstctl = lib.getExe' pkgs.dunst "dunstctl";
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

  my.desktop.keybinds = [
    {
      super = false;
      key = "F9";
      cmd = "${dunstctl} close";
    }
    {
      super = false;
      mod = "SHIFT";
      key = "F9";
      cmd = "${dunstctl} action";
    }
    {
      mod = "SHIFT";
      key = "F9";
      cmd = "${dunstctl} history-pop";
    }
    {
      key = "F9";
      cmd = lib.getExe (
        pkgs.writeShellScriptBin "mydunst-toggle" # sh
          ''
            function notify() {
              ${lib.my.mkNotification {
                title = "$1";
                body = "$2";
                tag = "mydunst";
              }}
            }

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
          ''
      );
    }
  ];
}
