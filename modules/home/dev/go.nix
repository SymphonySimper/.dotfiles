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

    programs.nixvim = {
      extraPackages = [
        pkgs.gofumpt
      ];

      lsp.servers = {
        gopls.enable = true;
        golangci_lint_ls.enable = true;
      };

      plugins.conform-nvim.formatters.go = [
        "goimports"
        "gofumpt"
      ];
      plugins.treesitter.grammars = [
        "go"
        "gomod"
        "gowork"
        "gosum"
      ];
    };
  };
}
