{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hardware.bluetooth;
in
{
  options.my.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth";
    blueman.enable = lib.mkEnableOption "Blueman";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        hardware.bluetooth = {
          enable = true; # enables support for Bluetooth
          powerOnBoot = true; # powers up the default Bluetooth controller on boot
        };
      }

      (lib.mkIf cfg.blueman.enable {
        services.blueman.enable = true; # gui
        environment.systemPackages = [
          # pkgs.overskride # gui
          pkgs.bluetui
        ];
      })
    ]
  );
}
