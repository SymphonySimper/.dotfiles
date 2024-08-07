# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  userSettings,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # fileSystems."/" =
  #   {
  #     device = "/dev/disk/by-uuid/4de83fef-619c-4d0a-98c5-89363dd878b3";
  #     fsType = "ext4";
  #   };
  #
  # fileSystems."/boot" =
  #   {
  #     device = "/dev/disk/by-uuid/A682-72F9";
  #     fsType = "vfat";
  #     options = [ "fmask=0022" "dmask=0022" ];
  #   };
  #
  # fileSystems."${userSettings.home}/importantnt" = {
  #   device = "/dev/disk/by-uuid/f8eb9e7d-83b6-4dec-9cc0-28e6894a229a";
  #   fsType = "ext4";
  # };

  # swapDevices =
  #   [{ device = "/dev/disk/by-uuid/28289b6f-56b3-4b27-b533-dba173f6ee97"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp12s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
