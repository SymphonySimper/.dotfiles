{ lib, config, ... }:
{
  config = lib.mkIf config.my.gui.de.enable {
    powerManagement.enable = true;

    services = {
      power-profiles-daemon.enable = false;
      thermald.enable = true;
      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };
    };
  };
}
