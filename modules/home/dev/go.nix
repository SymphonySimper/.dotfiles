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

    programs.neovim = {
      extraPackages = [
        pkgs.gofumpt

        pkgs.gopls
        pkgs.golangci-lint-langserver
      ];

      config = {
        conform = ''
          conform.formatters_by_ft.go = { "goimports", "gofumpt" } 
        '';

        lsp = ''
          vim.lsp.enable("gopls") 
          vim.lsp.enable("golangci_lint_ls")
        '';

        treeSitter.packages = [
          "go"
          "gomod"
          "gowork"
          "gosum"
        ];
      };
    };
  };
}
