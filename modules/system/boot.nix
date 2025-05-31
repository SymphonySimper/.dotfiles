{
  my,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my.boot;

  # for more versions: https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/linux-kernels.nix
  kernels = {
    lts = pkgs.linuxPackages;
    latest = pkgs.linuxPackages_latest;
  };
in
{
  options.my.boot = {
    enable = lib.mkEnableOption "boot";

    kernel = lib.mkOption {
      description = "Kernel to use";
      type = lib.types.oneOf [
        (lib.types.enum (builtins.attrNames kernels))
        lib.types.raw
      ];
      default = "lts";
    };
  };

  config = lib.mkIf cfg.enable {
    catppuccin.tty.enable = my.theme.dark;

    boot = {
      kernelPackages =
        if builtins.typeOf cfg.kernel == "string" then kernels.${cfg.kernel} else cfg.kernel;
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
