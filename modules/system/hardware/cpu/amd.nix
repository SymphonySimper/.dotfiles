{ lib, config, ... }:
{
  options.my.hardware.cpu.amd = {
    enable = lib.mkEnableOption "AMD CPU";
  };
  config = lib.mkIf config.my.hardware.cpu.amd.enable {
    boot = {
      kernelModules = [ "kvm-amd" ];
      kernelParams = [
        "amd_pstate=guided"
      ];
    };

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
