{
  my,
  pkgs,
  lib,
  ...
}:
let
  titleDefaultStyle = "normal";
  mkStyledText =
    {
      text,
      bold ? false,
      color ? my.theme.color.text,
    }:
    "<span foreground='${color}' font_weight='${if bold then "bold" else "normal"}'>${text}</span>";
  mkInfoLine =
    {
      title,
      titleStyle ? "normal",
      body,
    }:
    "<span><span font_weight='${titleStyle}'>${title}</span>: ${body}</span>";

  notifybar = lib.getExe (
    pkgs.writeShellScriptBin "mynotifybar" # sh
      ''
        # Date
        time_date_string="$(date '+%H:%M;%d/%m/%Y')"
        IFS=";"
        time_date=($time_date_string)
        unset IFS

        # Network
        network_status=$(nmcli -p -g type connection show --active | head -n1 | cut -d '-' -f3)
        network_title_style="${titleDefaultStyle}"
        network="''${network_status^}"
        case "$network_status" in
          ethernet) network_color="${my.theme.color.green}" ;;
          wireless) network_color="${my.theme.color.yellow}" ;;
          *)
            network="Disconnected"
            network_title_style="bold"
            network_color="${my.theme.color.red}"
          ;;
        esac
            
        # Battery
        battery_status=$(</sys/class/power_supply/BAT0/status)
        battery_capacity=$(</sys/class/power_supply/BAT0/capacity)
        battery_remaining_time=$(${lib.getExe pkgs.acpi} -r | ${lib.getExe' pkgs.coreutils "cut"} -d ' ' -f5)
        battery_title_style="${titleDefaultStyle}"
        case "$battery_status" in
        'Charging') battery_status_color="${my.theme.color.green}" ;;
        'Discharging') battery_status_color="${my.theme.color.maroon}" ;;
        esac
        if [ $battery_capacity -gt 80 ]; then
          battery_capacity_color="${my.theme.color.maroon}"
        elif [ $battery_capacity -gt 50 ]; then
          battery_capacity_color="${my.theme.color.green}"
        elif [ $battery_capacity -gt 20 ]; then
          battery_capacity_color="${my.theme.color.yellow}"
          battery_title_style="bold"
        else
          battery_capacity_color="${my.theme.color.red}"
          battery_title_style="bold"
        fi

        # Power Profile
        power_profile_status=$(myppd get)
        power_profile_title_style="${titleDefaultStyle}"
        if [ "$power_profile_status" == "power-saver" ]; then
          power_profile_color="${my.theme.color.green}"
        else
          power_profile_color="${my.theme.color.red}"
          power_profile_title_style="bold"
        fi

        # Refresh Rate
        refresh_rate_status=$(mychangefps get)
        refresh_rate_title_style="${titleDefaultStyle}"
        if [ $refresh_rate_status -eq ${my.gui.display.string.refreshRate} ]; then
          refresh_rate_color="${my.theme.color.green}"
        else
          refresh_rate_color="${my.theme.color.red}"
          refresh_rate_title_style="bold"
        fi

        # Brightness
        brightness_status=$(mybrightness -g)
        brightness_title_style="${titleDefaultStyle}"
        if [ $brightness_status -gt 80 ]; then
          brightness_color="${my.theme.color.red}"
          brightness_title_style="bold"
        elif [ $brightness_status -gt 50 ]; then
          brightness_color="${my.theme.color.maroon}"
          brightness_title_style="bold"
        elif [ $brightness_status -gt 20 ]; then
          brightness_color="${my.theme.color.yellow}"
        else
          brightness_color="${my.theme.color.green}"
        fi

        # Caffeine
        caffeine_inactive=$(mycaffeine -g)
        caffeine_title_style="${titleDefaultStyle}"
        if [ $caffeine_inactive -eq 1 ]; then
          caffeine_status="DISABLED"
          caffeine_color="${my.theme.color.overlay0}"
        else
          caffeine_status="ENABLED"
          caffeine_title_style="bold"
          caffeine_color="${my.theme.color.peach}"
        fi

        # Audio
        audio_mute=$(myvolume -gm)
        audio_volume=$(myvolume -gV)
        audio_title_style="${titleDefaultStyle}"
        if [ $audio_mute -eq 0 ]; then
          audio="MUTED"
          audio_title_style="bold"
          audio_color="${my.theme.color.red}"
        else
          audio="$audio_volume"
          if [ $audio_volume -gt 80 ]; then
            audio_color="${my.theme.color.red}"
            audio_title_style="bold"
          elif [ $audio_volume -gt 50 ]; then
            audio_color="${my.theme.color.maroon}"
            audio_title_style="bold"
          elif [ $audio_volume -gt 20 ]; then
            audio_color="${my.theme.color.yellow}"
          else
            audio_color="${my.theme.color.green}"
          fi
        fi

        # Mic
        mic_mute=$(myvolume -gM)
        mic_title_style="${titleDefaultStyle}"
        if [ $mic_mute -eq 0 ]; then
          mic="MUTED"
          mic_color="${my.theme.color.green}"
        else
          mic="UNMUTED"
          mic_title_style="bold"
          mic_color="${my.theme.color.red}"
        fi

        ${lib.my.mkNotification {
          tag = "notifybar";
          title = "Info";
          body = ''
            ${mkInfoLine {
              title = "Date";
              body = "${
                mkStyledText {
                  text = "\${time_date[0]}";
                  bold = true;
                }
              } ${
                mkStyledText {
                  text = "\${time_date[1]}";
                  bold = false;
                }
              }";
            }}
            ${mkInfoLine {
              title = "Network";
              titleStyle = "$network_title_style";
              body = mkStyledText {
                text = "$network";
                color = "$network_color";
              };
            }}
            ${mkInfoLine {
              title = "Battery";
              titleStyle = "$battery_title_style";
              body = "${
                mkStyledText {
                  text = "\${battery_capacity}%";
                  color = "$battery_capacity_color";
                }
              } (${
                mkStyledText {
                  text = "$battery_remaining_time"; # $battery_status
                  color = "$battery_status_color";
                }
              })";
            }}
            ${mkInfoLine {
              title = "Power Profile";
              titleStyle = "$power_profile_title_style";
              body = mkStyledText {
                text = "\${power_profile_status}";
                color = "$power_profile_color";
              };
            }}
            ${mkInfoLine {
              title = "Refresh Rate";
              titleStyle = "$refresh_rate_title_style";
              body = mkStyledText {
                text = "\${refresh_rate_status}Hz";
                color = "$refresh_rate_color";
              };
            }}
            ${mkInfoLine {
              title = "Brightness";
              titleStyle = "$brightness_title_style";
              body = mkStyledText {
                text = "\${brightness_status}%";
                color = "$brightness_color";
              };
            }}
            ${mkInfoLine {
              title = "Caffeine";
              titleStyle = "$caffeine_title_style";
              body = mkStyledText {
                text = "$caffeine_status";
                color = "$caffeine_color";
              };
            }}
            ${mkInfoLine {
              title = "Audio";
              titleStyle = "$audio_title_style";
              body = mkStyledText {
                text = "\${audio}%";
                color = "$audio_color";
              };
            }}
            ${mkInfoLine {
              title = "Mic";
              titleStyle = "$mic_title_style";
              body = mkStyledText {
                text = "$mic";
                color = "$mic_color";
              };
            }}
          '';
        }}
      ''
  );
in
{
  my.desktop.keybinds = [
    {
      key = "b";
      cmd = "${notifybar}";
    }
  ];
}
