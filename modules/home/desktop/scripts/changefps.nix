{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  jq = lib.getExe pkgs.jq;

  mkMonitor =
    refreshRate: # sh
    let
      monitorConfig = builtins.concatStringsSep ", " [
        my.gui.display.name
        "${my.gui.display.string.width}x${my.gui.display.string.height}@${refreshRate}Hz"
        "auto"
        my.gui.display.string.scale
        "vrr"
        (if my.gui.display.vrr then "1" else "0")
      ];
    in
    ''
      hyprctl keyword monitor '${monitorConfig}'
    '';

  changefps = lib.getExe (
    pkgs.writeShellScriptBin "mychangefps"
      # sh
      ''
        function get_rr() {
            hyprctl monitors -j | ${jq} '.[0].refreshRate' | cut -d '.' -f1
        }

        function notify() {
            ${lib.my.mkNotification {
              tag = "mychangefps";
              title = "RefreshRate is set to \${1}Hz";
            }}
        }

        function min() {
            ${mkMonitor my.gui.display.string.refreshRate}
            notify "${my.gui.display.string.refreshRate}"
        }

        function max() {
            ${mkMonitor my.gui.display.string.maxRefreshRate}
            notify "${my.gui.display.string.maxRefreshRate}"
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
      ''
  );
in
{
  my.programs.desktop = {
    keybinds = [
      {
        mod = "SHIFT";
        key = "F10";
        cmd = "${changefps} toggle";
      }
    ];

    notifybar.modules =
      let
        cfg = config.my.programs.desktop.notifybar;
      in
      [
        {
          name = "Refresh Rate";
          order.module = "Battery";
          logic = # sh
            ''
              refresh_rate_status=$(${changefps} get)
              refresh_rate_title_style="${cfg.style.normal}"

              if [ $refresh_rate_status <= 60 ]; then
                refresh_rate_color="${cfg.color.good}"
              else
                refresh_rate_color="${cfg.color.err}"
                refresh_rate_title_style="${cfg.style.bold}"
              fi
            '';
          style = "$refresh_rate_title_style";
          value = [
            {
              text = "\${refresh_rate_status}Hz";
              color = "$refresh_rate_color";
            }
          ];
        }
      ];
  };
}
