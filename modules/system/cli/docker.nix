{ lib, config, ... }:
{
  options.my.programs.docker = {
    enable = lib.mkEnableOption "Docker";
  };
  config = lib.mkIf config.my.programs.docker.enable {
    virtualisation.docker = {
      enable = true;
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
