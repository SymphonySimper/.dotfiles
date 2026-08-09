{
  den.aspects.apps.lang.go = {
    homeManager = { pkgs, lib, ... }: {
      home.packages = [
        pkgs.go
        pkgs.gotools
        pkgs.golangci-lint
      ];

      programs.helix = {
        lsp = {
          gopls.command = lib.getExe pkgs.gopls;
          golangci-lint-lsp.command = lib.getExe pkgs.golangci-lint-langserver;
        };

        lang.go = {
          formatter.command = lib.getExe' pkgs.gotools "goimports";
        };
      };
    };
  };
}
