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
      thermald.enable = config.my.hardware.cpu.intel.enable;
      tlp.enable = true;
    };
  };
}
