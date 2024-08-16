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
          function battery_notify() {
           ${
             myUtils.mkNotification {
               tag = "my-battery-status";
               title = "$1";
               urgency = "critical";
             }
           }
          }
          battery_status=$(</sys/class/power_supply/BAT0/status)
          battery_capacity=$(</sys/class/power_supply/BAT0/capacity)
          if [ $battery_capacity -gt 80 ] && [[ $battery_status == 'Charging' ]]; then
            battery_notify "Battery is greater than 80% ($battery_capacity) unplug the charger"
          fi
          if [ $battery_capacity -le 40 ] && [[ $battery_status == 'Discharging' ]]; then
            battery_notify "Battery is less than 40% ($battery_capacity) plug the charger"
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
