{
  my,
  pkgs,
  lib,
  ...
}:
let
  ctl = "${pkgs.sway}/bin/swaymsg";
  jq = "${pkgs.jq}/bin/jq";

  mkMonitor =
    refreshRate: vrr: # sh
    ''
      ${ctl} output ${my.gui.display.name} mode ${my.gui.display.string.width}x${my.gui.display.string.height}@${refreshRate}Hz
      sleep 1s
      ${ctl} output ${my.gui.display.name} adaptive_sync ${if vrr then "on" else "off"}
    '';
in
# sh
''
  function get_rr() {
      rr=$(${ctl} -t get_outputs --raw | ${jq} '.[0].current_mode.refresh')
      echo "$rr">> /tmp/toggle.log
      echo "$((rr/1000))"
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
