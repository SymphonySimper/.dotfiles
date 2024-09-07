{ config, lib, ... }:
let
  cfg = config.my.hardware.ideapad;
in
{
  options.my.hardware.ideapad = {
    enable = lib.mkEnableOption "ideapad";
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings = {
      "${config.my.user.name}-set-conservation-mode" = {
        "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode" = {
          "f+" = {
            group = "root";
            user = "root";
            mode = "0644";
            argument = "1";
          };
        };
      };
    };
  };
}
