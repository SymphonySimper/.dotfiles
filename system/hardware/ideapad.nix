{ userSettings, ... }:
{
  systemd.tmpfiles.settings = {
    "${userSettings.name.user}-set-conservation-mode" = {
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
}
