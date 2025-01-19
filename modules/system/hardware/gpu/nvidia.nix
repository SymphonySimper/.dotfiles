{ lib, config, ... }:
let
  cfg = config.my.hardware.gpu.nvidia;
in
{
  options.my.hardware.gpu.nvidia = {
    enable = lib.mkEnableOption "Nvidia GPU";
    disable = lib.mkOption {
      description = "Disable Nvidia GPU from loading";
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.disable {
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
      (lib.mkIf (!cfg.disable) {
        # refer: https://nixos.wiki/wiki/Nvidia#Installing_Nvidia_Drivers_on_NixOS

        # Enable OpenGL
        hardware.graphics.enable = true;

        # Load nvidia driver for Xorg and Wayland
        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {

          # Modesetting is required.
          modesetting.enable = true;

          # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          # Enable this if you have graphical corruption issues or application crashes after waking
          # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
          # of just the bare essentials.
          powerManagement.enable = false;

          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          powerManagement.finegrained = false;

          # Use the NVidia open source kernel module (not to be confused with the
          # independent third-party "nouveau" open source driver).
          # Support is limited to the Turing and later architectures. Full list of
          # supported GPUs is at:
          # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
          # Only available from driver 515.43.04+
          # Currently alpha-quality/buggy, so false is currently the recommended setting.
          open = false;

          # Enable the Nvidia settings menu,
          # accessible via `nvidia-settings`.
          nvidiaSettings = false;

          # Optionally, you may need to select the appropriate driver version for your specific GPU.
          package = config.boot.kernelPackages.nvidiaPackages.stable;

          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            # sync.enable = true;
            # Make sure to use the correct Bus ID values for your system!
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };
      })
    ]
  );
}
