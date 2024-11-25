{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.my.hardware.gpu.amd = {
    enable = lib.mkEnableOption "AMD GPU";
  };
  config = lib.mkIf config.my.hardware.gpu.amd.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          vulkan-loader
          vulkan-validation-layers
          vulkan-extension-layer
        ];
      };

      amdgpu.initrd.enable = true;
    };
  };
}
