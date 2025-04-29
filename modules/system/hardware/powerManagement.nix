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
      # TODO: enable whe cpu.intel is enabled
      thermald.enable = false;
      tlp.enable = true;
    };
  };
}
