{ ... }:
{
  my = {
    hardware = {
      cpu.amd.enable = true;
      gpu.amd.enable = true;

      bluetooth = {
        enable = true;
        blueman.enable = true;
      };

      ssd.enable = true;
      led.enable = true;
      logitech.enable = true;

      disko = {
        enable = true;
        disk = "/dev/nvme0n1";
        swap = "16G";
      };
    };

    programs.android.enable = true;
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
  ];
}
