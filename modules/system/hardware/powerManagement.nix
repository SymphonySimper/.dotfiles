{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hardware.powerManagement;
  ppd = lib.getExe config.services.power-profiles-daemon.package;
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
      power-profiles-daemon.enable = true;
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "myppd" # sh
        ''
          case "$1" in 
            get) ${ppd} get ;;
            max) ${ppd} set balanced ;;
            *) ${ppd} set power-saver ;;
          esac
        ''
      )
    ];
  };
}
