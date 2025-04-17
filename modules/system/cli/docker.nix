{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.docker;
in
{
  options.my.programs.docker = {
    enable = lib.mkEnableOption "Docker";
    enableRootless = lib.mkEnableOption "Rootless";
    enableGroup = lib.mkEnableOption "Docker group";
  };

  config = lib.mkIf cfg.enable {

    my = {
      programs.docker = {
        enableRootless = lib.mkDefault true;
        enableGroup = lib.mkDefault false;
      };

      user.groups = lib.optionals cfg.enableGroup [ "docker" ];
    };

    virtualisation.docker = lib.mkMerge [
      {
        enable = true;
        enableOnBoot = lib.mkDefault false;
        liveRestore = false;

        autoPrune.enable = true;
      }

      (lib.mkIf cfg.enableRootless {
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      })
    ];

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
