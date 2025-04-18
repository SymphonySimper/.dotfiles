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

  boot.binfmt.emulatedSystems = [
    "i686-linux"
    "aarch64-linux"
  ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  my = {
    networking.begone = {
      enable = true;

      allow = {
        yt = true;
        reddit = true;
        discord = true;
      };
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

    programs.docker.enable = true;
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
  ];
}
