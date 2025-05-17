{ config, lib, ... }:
let
  cfg = config.my.hardware.cpu;
in
{
  options.my.hardware.cpu = {
    amd.enable = lib.mkEnableOption "AMD";
    intel.enable = lib.mkEnableOption "Intel";
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !cfg.amd.enable || !cfg.intel.enable;
          message = "Cannot enable both CPUs";
        }
      ];
    }

    (lib.mkIf cfg.amd.enable {
      boot = {
        kernelModules = [ "kvm-amd" ];
        # kernelParams = [ "amd_pstate=guided" ];
      };

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    })

    (lib.mkIf cfg.intel.enable {
      boot.kernelModules = [ "kvm-intel" ];
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    })
  ];
}
