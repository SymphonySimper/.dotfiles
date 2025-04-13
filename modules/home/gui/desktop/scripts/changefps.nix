{
  my,
  pkgs,
  lib,
  ...
}:
let
  hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
  jq = lib.getExe pkgs.jq;

  mkMonitor =
    refreshRate: vrr: # sh
    ''
      ${hyprctl} keyword monitor '${my.gui.display.name}, ${my.gui.display.string.width}x${my.gui.display.string.height}@${refreshRate}Hz, auto, ${my.gui.display.string.scale}, vrr, ${if vrr then "1" else "0"}'
    '';

  changefps =
    pkgs.writeShellScriptBin "mychangefps"
      # sh
      ''
        function get_rr() {
            ${hyprctl} monitors -j | ${jq} '.[0].refreshRate' | cut -d '.' -f1
        }

        function notify() {
            ${lib.my.mkNotification {
              tag = "mychangefps";
              title = "RefreshRate is set to \${1}Hz";
            }}
        }

        function min() {
            ${mkMonitor my.gui.display.string.refreshRate false}
            notify "${my.gui.display.string.refreshRate}"
            myppd
        }

        function max() {
            ${mkMonitor my.gui.display.string.maxRefreshRate true}
            notify "${my.gui.display.string.maxRefreshRate}"
            myppd max
        }

        function toggle() {
          if [[ $(get_rr) -eq ${my.gui.display.string.maxRefreshRate} ]]; then
            min
          else
            max
          fi
        }

        case "$1" in
          get) get_rr ;;
          min) min ;;
          max) max ;;
          toggle) toggle ;;
        esac
      '';
in
{
  home.packages = [ changefps ];

  my.desktop.keybinds = [
    {
      mod = "SHIFT";
      key = "F10";
      cmd = "${lib.getExe changefps} toggle";
    }
  ];
}
