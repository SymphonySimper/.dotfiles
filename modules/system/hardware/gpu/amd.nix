{
  config,
  lib,
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
      };

      amdgpu.initrd.enable = true;
    };
  };
}
