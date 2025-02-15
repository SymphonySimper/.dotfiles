{
  my,
  pkgs,
  lib,
  ...
}:
let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  jq = "${pkgs.jq}/bin/jq";

  mkMonitor =
    refreshRate: vrr: # sh
    ''
      ${hyprctl} keyword monitor '${my.gui.display.name}, ${my.gui.display.string.width}x${my.gui.display.string.height}@${refreshRate}Hz, auto, ${my.gui.display.string.scale}, vrr, ${if vrr then "1" else "0"}'
    '';
in
# sh
''
  function get_rr() {
      ${hyprctl} monitors -j | ${jq} '.[0].refreshRate' | cut -d '.' -f1
  }

  function toggle() {
    rr_set=${my.gui.display.string.maxRefreshRate}
    if [[ $(get_rr) -eq ${my.gui.display.string.maxRefreshRate} ]]; then
      ${mkMonitor my.gui.display.string.refreshRate false}
      rr_set=${my.gui.display.string.refreshRate}
    else
      ${mkMonitor my.gui.display.string.maxRefreshRate true}
    fi

    ${lib.my.mkNotification { title = "RefreshRate is set to \${rr_set}Hz"; }}
  }

  case "$1" in
    get) get_rr ;;
    *) toggle ;;
  esac
''
