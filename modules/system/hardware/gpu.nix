{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.hardware.gpu;
in
{
  options.my.hardware.gpu = {
    amd.enable = lib.mkEnableOption "AMD";
    intel.enable = lib.mkEnableOption "Intel";

    nvidia = {
      enable = lib.mkEnableOption "Nvidia";
      disable = lib.mkEnableOption "Disable Nvidia";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.amd.enable || cfg.intel.enable || (cfg.nvidia.enable && (!cfg.nvidia.disable))) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    (lib.mkIf cfg.amd.enable {
      hardware = {
        graphics = lib.mkMerge [
          {
            # Vulkan
            extraPackages = [ pkgs.amdvlk ];
            extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
          }
          {
            # OpenCL
            extraPackages = [ pkgs.rocmPackages.clr.icd ];
          }
        ];

        amdgpu.initrd.enable = true;
      };
    })

    (lib.mkIf cfg.intel.enable {
      hardware.graphics.extraPackages = with pkgs; [
        intel-compute-runtime # OpenCL
        intel-media-driver # VA-API
        vpl-gpu-rt # https://wiki.nixos.org/wiki/Intel_Graphics#Quick_Sync_Video
      ];

      services.xserver.videoDrivers = [ "modesetting" ];
    })

    # Nvidia
    (lib.mkIf (cfg.nvidia.enable && (!cfg.nvidia.disable)) {
      # refer: https://nixos.wiki/wiki/Nvidia#Installing_Nvidia_Drivers_on_NixOS

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        open = lib.mkDefault false;
        modesetting.enable = true;
        nvidiaSettings = lib.mkDefault false;

        powerManagement.enable = false;
        powerManagement.finegrained = lib.mkDefualt false;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          # sync.enable = true;
          # Make sure to use the correct Bus ID values for your system!
          nvidiaBusId = lib.mkDefault "PCI:1:0:0";
          amdgpuBusId = lib.mkDefault (
            lib.strings.optionalString config.my.hardware.cpu.amd.enable "PCI:54:0:0"
          );
          intelBusId = lib.mkDefault (
            lib.strings.optionalString config.my.hardware.cpu.intel.enable "PCI:0:2:0"
          );
        };
      };
    })
    (lib.mkIf (cfg.nvidia.enable && cfg.nvidia.disable) {
      # refer: https://nixos.wiki/wiki/Nvidia#Disable_Nvidia_dGPU_completely
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';

      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
      ];
    })
  ];
}
