{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.go = {
    enable = lib.mkEnableOption "Go";
  };

  config = lib.mkIf config.dev.go.enable {
    home.packages = [
      pkgs.go
      pkgs.gotools
      pkgs.golangci-lint
    ];

    programs.helix = {
      lang.go.formatter.command = lib.getExe' pkgs.gotools "goimports";

      lsp = {
        gopls.command = lib.getExe pkgs.gopls;
        golangci-lint-lsp.command = lib.getExe pkgs.golangci-lint-langserver;
      };
    };
  };
}
