{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system
  ];

  my = {
    networking.begone = {
      enable = true;
      allow.discord = true;
    };

    hardware = {
      cpu.amd.enable = true;
      gpu.amd.enable = true;
      ssd.enable = true;
      led.enable = true;
      logitech.enable = true;
      disko = {
        enable = true;
        disk = "/dev/nvme0n1";
        swap = "16G";
      };
    };
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
  ];
}
