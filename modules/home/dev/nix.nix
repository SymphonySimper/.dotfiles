{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.nix = {
    enable = lib.mkEnableOption "Nix";
  };

  config = lib.mkIf config.dev.nix.enable {
    programs.neovim = {
      extraPackages = [
        pkgs.nixd
        pkgs.nixfmt
      ];

      config = {
        treeSitter.packages = [ "nix" ];

        conform = ''
          conform.formatters_by_ft.nix = { "nixfmt" }
        '';

        lsp = ''
          vim.lsp.enable('nixd')
          vim.lsp.config('nixd', {
             settings = {
               nixd = {
                 nixpkgs = { expr = "import <nixpkgs> { }" },
               },
             },
          });
        '';
      };
    };
  };
}
