{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.dev.docker;
in
{
  options.dev.docker = {
    enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf cfg.enable {
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

    programs.helix.lsp = {
      docker-langserver.command = lib.getExe pkgs.dockerfile-language-server;
    };
  };
}
