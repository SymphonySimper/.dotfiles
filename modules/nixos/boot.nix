{ config, lib, ... }:
let
  cfg = config.boot;
in
{
  options.boot = {
    enable = lib.mkEnableOption "Boot";
  };

  config = lib.mkMerge [
    # Clean /tmp folder on boot
    {
      boot.tmp.cleanOnBoot = true;
    }

    (lib.mkIf cfg.enable {
      boot.kernelParams = [ "quiet" ];
      boot.consoleLogLevel = 0;

      boot.loader = {
        efi.canTouchEfiVariables = true;

        systemd-boot = {
          enable = true;
          consoleMode = "5";
        };
      };
    })
  ];
}
