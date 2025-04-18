{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth";
  config = lib.mkIf config.my.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };

    # services.blueman.enable = true; # gui
    environment.systemPackages = [
      # pkgs.overskride # gui
      pkgs.bluetui
    ];
  };
}
