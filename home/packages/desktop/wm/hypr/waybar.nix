{
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  borderRadius = "8px"; # px value

  mkSpan =
    {
      prefix ? "",
      text ? "{}",
      suffix ? "",
    }:
    ''${
      if prefix != "" then "${prefix} " else ""
    }<span font-family="${userSettings.font.sans}">${text}${suffix}</span>'';

  micScript = pkgs.writeShellScriptBin "mic" ''
    on=""
    off=""

    if [[ $(volume -gM) -eq 0 ]]; then
    	text="$off"
    	class="off"
    	tooltip="No one can hear you."
    else
    	text="$on"
    	class="on"
    	tooltip="Everyone can hear you."
    fi

    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$text" "$class" "$tooltip"
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;

        # Gaps between modules
        spacing = 0;
        margin = "0";

        modules-left = [ "hyprland/workspaces" ];
        fixed-center = false;
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "temperature"
          "cpu"
          "memory"
          "battery"
          "network"
          "backlight"
          "wireplumber"
          "custom/mic"
          "idle_inhibitor"
          "custom/time"
          "custom/date"
          "tray"
        ];
        # Modules configuration
        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          format = "{icon}";
          # "persistent-workspaces"= {
          #   "*"= [1 2 3 4 5 6 7 8 9 10]
          # };
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
        };
        "hyprland/window" = {
          max-length = 40;
          format = "{}";
          separate-outputs = true;
        };
        temperature = {
          hwmon-path = "/tmp/temperature";
          critical-threshold = 80;
          format = mkSpan {
            prefix = "{icon}";
            text = "{temperatureC}";
            suffix = "°C";
          };
          format-icons = [
            ""
            ""
            ""
          ];
        };
        cpu = {
          format = mkSpan {
            prefix = "";
            text = "{usage}";
            suffix = "%";
          };
          states = {
            warning = 60;
            critical = 90;
          };
          tooltip = false;
        };
        memory = {
          format = mkSpan {
            prefix = "";
            suffix = "%";
          };
          states = {
            warning = 60;
            critical = 90;
          };
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = mkSpan {
            prefix = "{icon}";
            text = "{capacity}";
            suffix = "%";
          };
          format-charging = mkSpan {
            prefix = "";
            text = "{capacity}";
            suffix = "%";
          };
          format-plugged = mkSpan {
            prefix = "";
            text = "{capacity}";
            suffix = "%";
          };
          format-alt = mkSpan {
            prefix = "{icon}";
            text = "{time}";
          };

          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        network = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "";
          format-linked = "";
          on-right-click = "${userSettings.programs.terminal} -e nmtui";
          tooltip-format = mkSpan { text = "{ifname} via {gwaddr} "; };
          tooltip-format-wifi = mkSpan { text = "{essid} ({signalStrength}%) "; };
          tooltip-format-ethernet = mkSpan { text = "{ifname} {ipaddr}/{cidr} "; };
          tooltip-format-disconnected = mkSpan { text = "Disconnected"; };
        };
        backlight = {
          on-click = "brightness -t";
          on-scroll-up = "brightness -u";
          on-scroll-down = "brightness -d";
          format = mkSpan {
            prefix = "{icon}";
            text = "{percent}";
            suffix = "%";
          };
          tooltip = false;
          states = {
            warning = 60;
            critical = 90;
          };
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        wireplumber = {
          format = mkSpan {
            prefix = "{icon}";
            text = "{volume}";
            suffix = "%";
          };
          format-muted = "";
          scroll-step = 0.2;
          on-click = "volume -m";
          on-click-right = "pavucontrol";
          on-click-middle = "volume -s 30";
          on-scroll-up = "volume -u";
          on-scroll-down = "volume -d";
          states = {
            warning = 50;
            critical = 80;
          };
          format-icons = [
            ""
            ""
            ""
          ];
        };
        "custom/mic" = {
          exec = lib.getExe micScript;
          interval = "once";
          return-type = "json";
          signal = 8;
          on-click = "volume -M";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip-format-activated = mkSpan { text = "Activated"; };
          tooltip-format-deactivated = mkSpan { text = "Deactivated"; };
        };
        "custom/time" = {
          exec = "date '+%I:%M %p'";
          format = mkSpan { prefix = " "; };
          interval = 60;
        };
        "custom/date" = {
          exec = "date '+%d/%m/%y'";
          format = mkSpan { prefix = " "; };
          interval = 60;
        };
        tray = {
          spacing = 8;
        };
      };
    };

    style = # css
      ''
        * {
          font-family: ${userSettings.font.sans}, system-ui;
          font-size: 12px;
          min-height: 24px;
          min-width: 24px;
          border: none;
          border-radius: ${borderRadius};
          margin: 0;
          padding: 0;
        }

        window#waybar {
          background-color: transparent;
          color: @text;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        /* Modules Left */
        button {
          border-radius: 0;
        }

        button:hover {
          background: inherit;
        }

        #workspaces button,
        #window {
          margin-right: 1px;
          padding: 0 16px;
          color: @text;
          background-color: @base;
          /* border-right: 1px solid @surface0; */
        }

        #workspaces button:hover {
          color: @text;
          background-color: @base;
          border: none;
        }

        #workspaces button.persistent {
          color: @surface1;
          background-color: @base;
        }

        #workspaces button.active {
          color: @base;
          background-color: @text;
        }

        #workspaces button.urgent {
          color: @base;
          background-color: @sapphire;
        }

        #window {
          margin: 0;
          background-color: transparent;
        }

        #window.empty {
          background-color: transparent;
        }

        /* Modules Right */
        .modules-right > widget > * {
          font-family: "${userSettings.font.glyph}";
          background-color: @base;
          color: @text;
          padding: 0 16px;
          border-radius: 0;
          margin-right: 1px;
          /* border-right: 1px solid @surface0; */
        }

        tooltip {
          margin-top: 16px;
          border-radius: ${if borderRadius == "0" then "8px" else borderRadius};
          color: @text;
          background-color: @surface0;
        }

        tooltip label {
          font-size: 12px;
          padding: 4px 16px;
          color: @text;
          background-color: @surface0;
        }

        #workspaces button:first-child,
        #temperature,
        #backlight,
        #custom-time {
          border-radius: ${borderRadius} 0 0 ${borderRadius};
        }

        #workspaces button:last-child,
        #network,
        #idle_inhibitor,
        #custom-date {
          border: none;
          border-radius: 0 ${borderRadius} ${borderRadius} 0;
          margin-right: 8px;
        }

        #workspaces button:last-child,
        #custom-date {
          margin: 0;
        }

        #workspaces button:only-child {
          border-radius: ${borderRadius};
        }

        #idle_inhibitor.activated {
          color: @crust;
          background-color: @flamingo;
        }

        @keyframes blink {
          to {
            background-color: @red;
            color: @base;
          }
        }

        #network,
        #battery.plugged {
          background-color: @green;
          color: @base;
        }

        #cpu.warning,
        #memory.warning,
        #battery.warning,
        #network.linked,
        #backlight.warning,
        #wireplumber.warning {
          background-color: @yellow;
          color: @base;
        }

        #network.disconnected,
        #wireplumber.muted,
        #custom-mic.off {
          background-color: @peach;
          color: @base;
        }

        #temperature.critical,
        #cpu.critical,
        #memory.critical,
        #network.disabled,
        #backlight.critical,
        #wireplumber.critical {
          background-color: @red;
          color: @base;
        }

        #battery.critical:not(.charging) {
          background-color: @red;
          color: @maroon;
          animation-name: blink;
          animation-duration: 1.5s;
          animation-timing-function: ease;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #tray {
          border-radius: ${borderRadius};
          margin-right: 0;
          margin-left: 8px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @sapphire;
        }
      '';
  };
}
