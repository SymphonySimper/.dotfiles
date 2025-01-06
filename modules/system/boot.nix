{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my.boot;
in
{
  options.my.boot = {
    enable = lib.mkEnableOption "boot";
  };

  config = lib.mkIf cfg.enable {
    catppuccin.tty.enable = false;

    # Bootloader.
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "5";
        };
        efi.canTouchEfiVariables = true;
      };
      kernelParams = [ "quiet" ];
      consoleLogLevel = 0;
    };
  };
}
