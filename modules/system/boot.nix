{ lib, config, ... }:
let
  cfg = config.my.boot;
in
{
  options.my.boot = {
    enable = lib.mkEnableOption "boot";
  };

  config = lib.mkIf cfg.enable {
    # Bootloader.
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "max";
        };
        efi.canTouchEfiVariables = true;
      };
      kernelParams = [ "quiet" ];
      consoleLogLevel = 0;
    };
  };
}
