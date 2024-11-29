{ lib, config, ... }:
{
  options.my.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth";
  config = lib.mkIf config.my.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
}
