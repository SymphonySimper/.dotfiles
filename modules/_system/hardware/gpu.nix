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
    amd = {
      enable = lib.mkEnableOption "AMD";
      enableVulkan = lib.mkEnableOption "AMDVULK";
    };

    intel.enable = lib.mkEnableOption "Intel";
    nvidia.enable = lib.mkEnableOption "Nvidia";
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.amd.enable || cfg.intel.enable || cfg.nvidia.enable) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    })

    (lib.mkIf cfg.amd.enable {
      hardware = {
        amdgpu.initrd.enable = true;

        graphics = {
          extraPackages = [
            pkgs.rocmPackages.clr.icd # OpenCL
          ]
          ++ (lib.lists.optional cfg.amd.enableVulkan pkgs.amdvlk);
          extraPackages32 = lib.lists.optional cfg.amd.enableVulkan pkgs.driversi686Linux.amdvlk;
        };
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
  ];
}
