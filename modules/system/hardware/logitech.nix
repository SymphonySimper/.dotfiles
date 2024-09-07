{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.logitech;
in
{
  options.my.hardware.logitech = {
    enable = lib.mkEnableOption "logitech";
  };

  config = lib.mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;

    environment.systemPackages = [ pkgs.solaar ];
  };
}
