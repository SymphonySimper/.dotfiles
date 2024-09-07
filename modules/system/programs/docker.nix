{ lib, config, ... }:
let
  cfg = config.my.system.programs.docker;
in
{
  options.my.system.programs.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
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
