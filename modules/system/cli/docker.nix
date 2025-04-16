{
  config,
  pkgs,
  lib,
  ...
}:
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

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "mydocker" # sh
        ''
          case "$1" in
            cln|clean)
              docker system prune --volumes
              docker image prune -a
            ;;
          esac
        ''
      )
    ];
  };
}
