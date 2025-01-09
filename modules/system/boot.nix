{
  my,
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
    catppuccin.tty.enable = my.theme.dark;

    # Bootloader.
    boot = {
      # lts: `pkgs.linuxPackages`
      # latest: `pkgs.linuxPackages_latest`
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
