{ lib, config, ... }:
{
  # Bootloader.
  boot = {
    # Clean /tmp folder on boot
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };

    loader = lib.mkIf config.my.gui.de.enable {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = lib.mkIf config.my.gui.de.enable [ "quiet" ];
    consoleLogLevel = lib.mkIf config.my.gui.de.enable 0;
  };
}
