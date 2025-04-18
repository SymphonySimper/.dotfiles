{
  my,
  pkgs,
  lib,
  ...
}:
let
  caffeine =
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
            if [ $is_inactive -eq 0 ]; then
              handle_idle start
              noti "Disabled"
            else
              handle_idle stop
              noti "Enabled"
            fi
            ;;
        esac
      '';
in
{
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

  home.packages = [ caffeine ];
  my.desktop.keybinds = [
    {
      key = "F10";
      cmd = "${lib.getExe caffeine}";
    }
  ];

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = false;
        hide_cursor = true;
      };

      background.color = "$base";
    };
  };

  catppuccin.hyprlock = {
    flavor = my.theme.flavors.dark;
    useDefaultConfig = false;
  };
}
