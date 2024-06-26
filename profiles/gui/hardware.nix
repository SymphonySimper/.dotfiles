# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, userSettings, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/e98c696f-ef24-4096-9649-06069b3a9d0e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D313-7A42";
      fsType = "vfat";
    };

  fileSystems."${userSettings.home}/importantnt" = {
    device = "/dev/disk/by-uuid/f8eb9e7d-83b6-4dec-9cc0-28e6894a229a";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f8941864-8f14-4b71-89a8-16f447e4c999"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp12s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
