{ ... }:
{
  my = {
    networking.begone.enable = true;

    hardware = {
      cpu.amd.enable = true;
      gpu.amd.enable = true;

      bluetooth.enable = true;
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
