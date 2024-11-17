{ lib, config, ... }:
{
  options.my.system.docker = {
    enable = lib.mkEnableOption "Docker";
  };
  config = lib.mkIf config.my.system.docker.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = lib.mkForce false;
      liveRestore = false;

      autoPrune = {
        enable = true;
      };

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
