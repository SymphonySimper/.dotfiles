{
  config,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ../../modules/system/hardware/disko.nix {
      inherit inputs;
      device = "/dev/nvme0n1";
      swap = "16G";
    })
    ../../modules/system
  ];

  boot.binfmt.emulatedSystems = [
    "i686-linux"
    "aarch64-linux"
  ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  my = {
    hardware = {
      cpu.amd.enable = true;
      gpu.amd.enable = true;
      ssd.enable = true;
      led.enable = true;
      logitech.enable = true;
    };

    programs.gaming = {
      enable = true;
      display = {
        width = 1920;
        height = 1200;
      };
    };
    networking.begone.enable = true;
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
  ];
}
