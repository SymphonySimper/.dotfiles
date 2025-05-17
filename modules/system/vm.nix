{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vm;
in
{
  options.my.programs.vm = {
    enable = lib.mkEnableOption "VM";

    docker = {
      enable = lib.mkEnableOption "Docker";
      enableRootless = lib.mkEnableOption "Rootless";
      enableGroup = lib.mkEnableOption "Docker group";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      services = {
        spice-webdavd.enable = true;
        spice-vdagentd.enable = true;
      };

      environment.systemPackages = with pkgs; [ virtiofsd ];
    })

    (lib.mkIf cfg.docker.enable {
      my = {
        programs.vm.docker = {
          enableRootless = lib.mkDefault true;
          enableGroup = lib.mkDefault false;
        };

        user.groups = lib.optionals cfg.docker.enableGroup [ "docker" ];
      };

      virtualisation.docker = lib.mkMerge [
        {
          enable = true;
          enableOnBoot = lib.mkDefault false;
          liveRestore = false;

          autoPrune.enable = true;
        }

        (lib.mkIf cfg.docker.enableRootless {
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
    })
  ];
}
