{ lib, config, ... }:
{
  options.my.hardware.ssd = {
    enable = lib.mkEnableOption "SSD";
  };

  config = lib.mkIf config.my.hardware.ssd.enable {
    services.fstrim.enable = true;
  };
}
