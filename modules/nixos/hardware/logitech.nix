{ config, lib, ... }:
let
  cfg = config.hardware.logitech.wireless;
in
{
  options.hardware.logitech.wireless.wakeup = {
    enable = lib.mkEnableOption "Enable wakeup";

    id = lib.mkOption {
      type = lib.types.submodule {
        options = {
          vendor = lib.mkOption {
            type = lib.types.str;
          };

          product = lib.mkOption {
            type = lib.types.str;
          };
        };
      };

      description = ''
        To get idVendor and idProduct run
        ```
         nix shell nixpkgs#usbutils
         lsusb | grep Logitech
        ```
        sample output: Bus 001 Device 006: ID 046d:c548 Logitech, Inc. Logi Bolt Receiver
        Where `ID <idVendor:idProduct>`
      '';

      default = {
        vendor = "046d";
        product = "c548";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Disable wakeup for logibolt
    # refer: https://wiki.archlinux.org/title/Power_management/Wakeup_triggers#Event-driven_with_udev
    # refer: https://forum.manjaro.org/t/disabled-every-device-in-acpi-wakeup-and-my-logi-bolt-receiver-still-wakes-computer-immediately-after-suspend/138355/2
    # Once rule is set run `sudo udevadm control --reload-rules` for the first time.
    services.udev.extraRules = lib.mkIf (!cfg.wakeup.enable) ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="${cfg.wakeup.id.vendor}", ATTRS{idProduct}=="${cfg.wakeup.id.product}", ATTR{power/wakeup}="disabled"
    '';
  };
}
