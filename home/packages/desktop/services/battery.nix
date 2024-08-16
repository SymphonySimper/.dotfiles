{ pkgs, myUtils, ... }:
let
  name = "my-battery";
  time = "5m";
in
{
  systemd.user.services.${name} = {
    Unit.Description = "Battery check";
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.lib.getExe (
        pkgs.writeShellScriptBin "my-battery" ''
          tmp_file='/tmp/${name}'

          function battery_notify() {
           ${
             myUtils.mkNotification {
               tag = "my-battery-status";
               title = "$1";
               urgency = "critical";
             }
           }
          }

          function default_temp_file() {
            echo -1 > "$tmp_file";
          }

          battery_status=$(</sys/class/power_supply/BAT0/status)
          battery_capacity=$(</sys/class/power_supply/BAT0/capacity)

          if [ $battery_capacity -gt 80 ] && [[ $battery_status == 'Charging' ]]; then
            battery_notify "Battery is greater than 80% ($battery_capacity) unplug the charger"
          fi
          if [ $battery_capacity -le 40 ] && [[ $battery_status == 'Discharging' ]]; then
            if [ ! -f "$tmp_file" ]; then
              default_temp_file
            fi

            time_left=$(<"$tmp_file")
            if [[ $time_left -eq -1 ]]; then
              battery_notify "Battery is less than 40% ($battery_capacity) plug the charger"
              echo 1 > "$tmp_file"
            else
              if [[ $time_left -eq 0 ]]; then
                default_temp_file
              else
                echo $((time_left - 1)) > "$tmp_file"
              fi
            fi
          fi
        ''
      );
    };
  };

  systemd.user.timers."${name}.timer" = {
    Unit = {
      Description = "Run battery check every 1m";
    };
    Timer = {
      OnBootSec = "${time}";
      OnUnitActiveSec = "${time}";
      Unit = "${name}.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
