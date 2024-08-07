{
  lib,
  pkgs,
  userSettings,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64-installer.nix")
    ../../system/default.nix
    ../../system/hardware/logitech.nix
    ../../system/pc.nix
    ./hardware.nix
  ];

  sdImage.compressImage = false;

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  # Create gpio group
  users.groups.gpio = { };

  # Change permissions gpio devices
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  users.users.${userSettings.name.user}.extraGroups = [ "gpio" ];

  services = {
    thermald.enable = lib.mkForce false;
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
  };

  networking = {
    hostName = lib.mkForce "pi";
    useDHCP = true;
    networkmanager.enable = lib.mkForce false;
    firewall.enable = lib.mkForce false;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      networks = {
        "Doreamon" = {
          pskRaw = "<PASSWORD>"; # gen using wpa_passphrase <SSID> <PASSWORD>
        };
      };
    };
  };
}
