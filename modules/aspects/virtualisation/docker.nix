{ lib, ... }: {
  den.aspects.virtualisation.docker = {
    nixos = {
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

    homeManager = { pkgs, ... }: {
      home.packages = [
        (pkgs.writeShellScriptBin "mydocker" ''
          case "$1" in
            cln|clean)
              docker system prune --volumes
              docker image prune -a
            ;;
          esac
        '')
      ];

      programs.helix.languages = {
        language-server.docker-langserver.command = lib.getExe pkgs.dockerfile-language-server;
      };
    };
  };
}
