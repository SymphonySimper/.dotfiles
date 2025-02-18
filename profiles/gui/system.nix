{
  config,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system
  ];

  boot = {
    kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
    binfmt.emulatedSystems = [
      "i686-linux"
      "aarch64-linux"
    ];
  };
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  my = {
    networking.begone.enable = true;
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

    programs = {
      vm.waydroid.enable = true;
      steam = {
        enable = false;
        display = {
          width = 1920;
          height = 1200;
        };
      };
    };
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
  ];
}
