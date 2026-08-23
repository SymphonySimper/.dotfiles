{ config, lib, ... }:
{
  config = lib.mkIf config.virtualisation.docker.enable {
    virtualisation.docker = {
      enableOnBoot = lib.mkDefault false;
      liveRestore = false;

      autoPrune.enable = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
