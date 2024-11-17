{
  lib,
  config,
  my,
  ...
}:
{
  options.my.hardware.ideapad = {
    enable = lib.mkEnableOption "Ideapad";
  };
  config = lib.mkIf config.my.hardware.ideapad.enable {
    systemd.tmpfiles.settings = {
      "${my.name}-set-conservation-mode" = {
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
