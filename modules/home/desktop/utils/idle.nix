{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  caffeine = lib.getExe (
    pkgs.writeShellScriptBin "mycaffeine" # sh
      ''
        handle_idle() {
          systemctl $1 --user hypridle;
        }

        noti() {
          ${lib.my.mkNotification {
            tag = "mycaffeine";
            title = "Caffeine $1";
          }}
        }

        get_status() {
          handle_idle status | grep -q 'inactive' && echo 0 || echo 1
        }

        case "$1" in
          -g) get_status ;;
           *)
            is_inactive=$(get_status)
            if [[ $is_inactive -eq 0 ]]; then
              handle_idle start
              noti "Disabled"
            else
              handle_idle stop
              noti "Enabled"
            fi
            ;;
        esac
      ''
  );
in
{
  config = lib.mkIf config.my.programs.desktop.enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 120;
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 300;
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };

    my.programs.desktop = {
      keybinds = [
        {
          key = "F10";
          cmd = "${caffeine}";
        }
      ];

      notifybar.modules =
        let
          cfg = config.my.programs.desktop.notifybar;
        in
        [
          {
            name = "Caffeine";
            order.module = "Brightness";
            logic = # sh
              ''
                caffeine_inactive=$(${caffeine} -g)
                caffeine_title_style="${cfg.style.normal}"
                if [[ $caffeine_inactive -eq 1 ]]; then
                  caffeine_status="DISABLED"
                  caffeine_color="${cfg.color.disabled}"
                else
                  caffeine_status="ENABLED"
                  caffeine_title_style="bold"
                  caffeine_color="${my.theme.color.peach}"
                fi
              '';
            style = "$caffeine_title_style";
            value = [
              {
                text = "$caffeine_status";
                color = "$caffeine_color";
              }
            ];
          }
        ];
    };

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
          fractional_scaling = 0;
        };

        background.color = "$base";

        input-field =
          let
            outlineThickness = 4;
            padding = outlineThickness + 16;
            width = builtins.toString (my.gui.display.width - padding);
            height = builtins.toString (my.gui.display.height - padding);
          in
          {
            size = "${width}, ${height}";
            outline_thickness = outlineThickness;
            outer_color = "$surface0";
            inner_color = "$base";
            font_color = "$overlay0";
            font_family = my.theme.font.mono;
            placeholder_text = "";
            hide_input = true;
            hide_input_base_color = "$accent";
            rounding = 0;
            check_color = "$text";
            fail_color = "$red";
            fail_text = "";
            position = "0, 0";
            halign = "center";
            valign = "center";
            zindex = 0;
          };

        label =
          let
            timeFontSize = 90;
            dateFontSize = timeFontSize / 4;
            mkY = value: builtins.toString (value / 2 + 16);
          in
          [
            {
              # Date
              text = "cmd[update:60000] ${lib.getExe' pkgs.coreutils "date"} +'%A, %d %B %Y'"; # update every 60 seconds
              font_size = dateFontSize;
              font_family = my.theme.font.mono;
              color = "$text";
              position = "0, ${mkY dateFontSize}";
              halign = "center";
              valign = "center";
            }
            {
              # Time
              text = "$TIME";
              font_size = timeFontSize;
              font_family = my.theme.font.mono;
              color = "$text";
              position = "0, -${mkY timeFontSize}";
              halign = "center";
              valign = "center";
            }
          ];
      };
    };

    catppuccin.hyprlock = {
      flavor = my.theme.flavors.dark;
      useDefaultConfig = false;
    };
  };
}
