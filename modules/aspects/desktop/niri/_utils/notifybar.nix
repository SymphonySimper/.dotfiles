{
  den.aspects.options = {
    homeManager.options.desktop.niri =
      { config, lib, ... }:
      let
        defaultStyle = lib.attrsets.genAttrs [ "normal" "bold" ] (name: name);
        defaultColors = {
          default = config.theme.color.text;
          good = config.theme.color.green;
          ok = config.theme.color.yellow;
          warn = config.theme.color.maroon;
          err = config.theme.color.red;
          disabled = config.theme.color.overlay0;
        };

        mkReadOnlyOption =
          type: default:
          lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            description = "Default ${type}";
            readOnly = true;
            inherit default;
          };
      in
      {
        notifybar = lib.mkOption {
          type = lib.types.submodule {
            options = {
              style = mkReadOnlyOption "style" defaultStyle;
              color = mkReadOnlyOption "color" defaultColors;

              modules = lib.mkOption {
                type = lib.types.listOf (
                  lib.types.submodule {
                    options = {
                      name = lib.mkOption {
                        type = lib.types.str;
                        description = "Name of the module";
                      };

                      order = lib.mkOption {
                        type = lib.types.submodule {
                          options = {
                            type = lib.mkOption {
                              type = lib.types.enum [
                                "before"
                                "after"
                              ];
                              description = "Odering type of the module";
                              default = "after";
                            };

                            module = lib.mkOption {
                              type = lib.types.nullOr lib.types.str;
                              description = "Name of the module that should be palce before/after this module";
                            };
                          };
                        };
                      };

                      style = lib.mkOption {
                        type = lib.types.str;
                        description = "Style of the module";
                      };

                      logic = lib.mkOption {
                        type = lib.types.lines;
                        description = "Logic of the module";
                      };

                      value = lib.mkOption {
                        type = lib.types.listOf (
                          lib.types.submodule {
                            options = {
                              text = lib.mkOption {
                                type = lib.types.str;
                                description = "Text to be shown";
                              };

                              color = lib.mkOption {
                                type = lib.types.str;
                                description = "color of body";
                                default = defaultColors.default;
                              };

                              style = lib.mkOption {
                                type = lib.types.enum (builtins.attrValues defaultStyle);
                                description = "Style of body";
                                default = defaultStyle.normal;
                              };

                              prefix = lib.mkOption {
                                type = lib.types.str;
                                description = "Prefix for text";
                                default = "";
                              };

                              suffix = lib.mkOption {
                                type = lib.types.str;
                                description = "Suffix for text";
                                default = "";
                              };
                            };
                          }
                        );
                        description = "Body of the module";
                      };
                    };
                  }
                );
                description = "Modules to be shown and key should be the order ex: 0";
              };
            };
          };
          description = "Things to show in notification";
        };
      };
  };

  den.aspects.desktop.niri = {
    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        cfg = config.desktop.niri.notifybar;

        notifybar =
          let
            sorted = lib.hm.dag.topoSort (
              lib.attrsets.listToAttrs (
                map (
                  module:
                  let
                    order = if module.order.type == "before" then lib.hm.dag.entryBefore else lib.hm.dag.entryAfter;
                  in
                  {
                    name = module.name;
                    value = order [ module.order.module ] module;
                  }
                ) cfg.modules
              )
            );
          in
          lib.trivial.throwIfNot (sorted ? result) "Failed to build notifybar!" (
            map (
              module:
              let
                mod = module.data;

                mkText =
                  {
                    text,
                    style,
                    color ? cfg.color.default,
                    prefix ? "",
                    suffix ? "",

                  }:
                  "${prefix}<span foreground='${color}' font_weight='${style}'>${text}</span>${suffix}";

                title = mkText {
                  text = module.name;
                  style = mod.style;
                };

                body = builtins.concatStringsSep "" (
                  map (
                    v:
                    mkText {
                      text = v.text;
                      color = v.color;
                      style = v.style;
                      prefix = v.prefix;
                      suffix = v.suffix;
                    }
                  ) mod.value
                );
              in
              {
                logic = mod.logic;
                notify = "<span>${title}: ${body}</span>";
              }
            ) sorted.result
          );
      in
      {
        desktop.niri.keybinds = [
          {
            key = "b";
            cmd = lib.getExe (
              pkgs.writeShellScriptBin "mynotifybar" (
                lib.strings.concatLines (
                  builtins.concatLists [
                    (map (nb: nb.logic) notifybar)
                    [
                      (lib.my.mkNotification {
                        tag = "notifybar";
                        title = "Info";
                        body = (lib.strings.concatLines (map (nb: nb.notify) notifybar));
                      })
                    ]
                  ]
                )
              )
            );
          }
        ];

        desktop.niri.notifybar.modules =
          let
            coreutils = lib.attrsets.genAttrs [ "cut" "head" ] (e: lib.getExe' pkgs.coreutils e);
          in
          [
            {
              name = "Date";

              order = {
                type = "before";
                module = "Network";
              };

              style = "normal";
              logic = # sh
                ''
                  time_date_string="$(date '+%H:%M;%d/%m/%Y')"
                  IFS=";"
                  read -ra time_date <<<"$time_date_string"
                  unset IFS
                '';
              value = [
                {
                  text = "\${time_date[0]}";
                  style = cfg.style.bold;
                }
                {
                  prefix = " ";
                  text = "\${time_date[1]}";
                }
              ];
            }
            {
              name = "Network";
              order.module = "Date";
              logic = # sh
                ''
                  network_status=$(${lib.getExe' pkgs.networkmanager "nmcli"} -p -g type connection show --active | ${coreutils.head} -n1 | ${coreutils.cut} -d '-' -f3)
                  network_title_style="${cfg.style.normal}"
                  network="''${network_status^}"
                  case "$network_status" in
                    ethernet network_color="${cfg.color.good}" ;;
                    wireless) network_color="${cfg.color.ok}" ;;
                    *)
                      network="Disconnected"
                      network_title_style="${cfg.style.bold}"
                      network_color="${cfg.color.err}"
                    ;;
                  esac
                '';
              style = "$network_title_style";
              value = [
                {
                  text = "$network";
                  color = "$network_color";
                }
              ];
            }
            {
              name = "Battery";
              order.module = "Network";
              logic = # sh
                ''
                  battery_status=$(</sys/class/power_supply/BAT0/status)
                  battery_capacity=$(</sys/class/power_supply/BAT0/capacity)
                  battery_remaining_time=$(${lib.getExe pkgs.acpi} -r | ${coreutils.cut} -d ' ' -f5)
                  battery_title_style="${cfg.style.normal}"

                  case "$battery_status" in
                  'Charging') battery_status_color="${cfg.color.good}" ;;
                  'Discharging') battery_status_color="${cfg.color.warn}" ;;
                  esac

                  if [[ $battery_capacity -gt 80 ]]; then
                    battery_capacity_color="${cfg.color.warn}"
                  elif [[ $battery_capacity -gt 50 ]]; then
                    battery_capacity_color="${cfg.color.good}"
                  elif [[ $battery_capacity -gt 20 ]]; then
                    battery_capacity_color="${cfg.color.ok}"
                    battery_title_style="${cfg.style.bold}"
                  else
                    battery_capacity_color="${cfg.color.err}"
                    battery_title_style="${cfg.style.bold}"
                  fi
                '';
              style = "$battery_title_style";
              value = [
                {
                  text = "\${battery_capacity}%";
                  color = "$battery_capacity_color";
                  suffix = " ";
                }
                {
                  prefix = "(";
                  suffix = ")";
                  text = "$battery_remaining_time";
                  color = "$battery_status_color";
                }
              ];
            }
            {
              name = "Power Profile";
              order.module = "Brightness";
              logic = # sh
                ''
                  power_profile_status=$(myppd get)
                  power_profile_title_style="${cfg.style.normal}"
                  if [ "$power_profile_status" == "power-saver" ]; then
                    power_profile_color="${cfg.color.good}"
                  elif [ "$power_profile_status" == "balanced" ]; then
                    power_profile_color="${cfg.color.ok}"
                  else
                    power_profile_color="${cfg.color.err}"
                    power_profile_title_style="${cfg.style.bold}"
                  fi
                '';
              style = "$power_profile_title_style";
              value = [
                {
                  text = "\${power_profile_status}";
                  color = "$power_profile_color";
                }
              ];
            }
            {
              name = "Bluetooth";
              order.module = "Mic";
              logic = # sh
                ''
                  bluetooth_color="${cfg.color.disabled}"
                  bluetooth_title_style="${cfg.style.normal}"

                  bluetooth_exists=$(command -v "bluetoothctl")
                  if [ -z "$bluetooth_exists" ]; then
                    bluetooth_status="Disabled"
                  else
                    readarray -t bluetooth_connected_devices < <(${lib.getExe' pkgs.bluez "bluetoothctl"} devices Connected | ${lib.getExe' pkgs.gnugrep "grep"} 'Device' | cut -d ' ' -f3-)

                    if [[ "''${bluetooth_connected_devices[@]}" -eq 0 ]]; then
                      bluetooth_status="No devices connected."
                      bluetooth_color="${cfg.color.ok}"
                    else
                      bluetooth_title_style="${cfg.style.bold}"
                      bluetooth_connected_devices_join=$(IFS=', '; echo "''${bluetooth_connected_devices[*]}")
                      bluetooth_status="''${bluetooth_connected_devices_join//,/, }"
                      bluetooth_color="${cfg.color.default}"
                    fi
                  fi
                '';
              style = "$bluetooth_title_style";
              value = [
                {
                  text = "$bluetooth_status";
                  color = "$bluetooth_color";
                }
              ];
            }
          ];
      };
  };
}
