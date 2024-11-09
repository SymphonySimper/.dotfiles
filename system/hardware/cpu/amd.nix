{ lib, config, ... }:
{
  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "amd_pstate=guided"
    ];
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}