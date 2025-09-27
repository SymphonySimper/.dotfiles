{ config, lib, ... }:
let
  cfg = config.my.hardware.powerManagement;
in
{
  options.my.hardware.powerManagement = {
    enable = lib.mkEnableOption "power management";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = true;

    services = {
      power-profiles-daemon.enable = true;
      thermald.enable = config.my.hardware.cpu.intel.enable;
      auto-cpufreq.enable = lib.mkForce false;
      tlp.enable = lib.mkForce false;
    };
  };
}
