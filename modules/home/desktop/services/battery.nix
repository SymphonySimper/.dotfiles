{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.programs.desktop.enable (
    lib.my.mkSystemdTimer rec {
      name = "my-battery";
      time = "5m";
      desc = "Battery check";
      ExecStart = lib.getExe (
        pkgs.writeShellScriptBin "my-battery" ''
          tmp_file='/tmp/${name}'

          function battery_notify() {
           ${lib.my.mkNotification {
             tag = "my-battery-status";
             title = "$1";
             urgency = "critical";
           }}
          }

          function default_temp_file() {
            echo -1 > "$tmp_file";
          }

          battery_acpi=$(${lib.getExe pkgs.acpi} -r)
          battery_acpi="''${battery_acpi#*:[[:space:]]}"

          battery_status="''${battery_acpi%%,*}"

          battery_capacity="''${battery_acpi#*,[[:space:]]}"
          battery_capacity="''${battery_capacity%%%*}"

          if [[ $battery_capacity -gt 80 ]] && [[ $battery_status == 'Charging' ]]; then
            battery_notify "Battery is greater than 80% ($battery_capacity) unplug the charger"
          fi

          if [[ $battery_capacity -le 40 ]] && [[ $battery_status == 'Discharging' ]]; then
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
    }
  );
}
