{
  pkgs,
  lib,
  my,
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
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "notifybar" ''

      # Date
      time_date_string="$(date '+%H:%M;%d/%m/%Y')"
      IFS=";"
      time_date=($time_date_string)
      unset IFS

      # Battery
      battery_status=$(cat /sys/class/power_supply/BAT0/status)
      battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
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

      # Brightness
      brightness_status=$(brightness -g)
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

      # Caffiene
      caffiene_inactive=$(caffiene -g)
      caffiene_title_style="${titleDefaultStyle}"
      if [ $caffiene_inactive -eq 1 ]; then
        caffiene_status="DISABLED"
        caffiene_color="${my.theme.color.overlay0}"
      else
        caffiene_status="ENABLED"
        caffiene_title_style="bold"
        caffiene_color="${my.theme.color.peach}"
      fi

      # Audio
      audio_mute=$(volume -gm)
      audio_volume=$(volume -gV)
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
      mic_mute=$(volume -gM)
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
            title = "Battery";
            titleStyle = "$battery_title_style";
            body = "${
              mkStyledText {
                text = "\${battery_capacity}%";
                color = "$battery_capacity_color";
              }
            } (${
              mkStyledText {
                text = "$battery_status";
                color = "$battery_status_color";
              }
            })";
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
            title = "Caffiene";
            titleStyle = "$caffiene_title_style";
            body = mkStyledText {
              text = "$caffiene_status";
              color = "$caffiene_color";
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
    '')
  ];
}
