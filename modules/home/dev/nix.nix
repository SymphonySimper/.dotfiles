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
    programs.nixvim = {
      extraPackages = [
        pkgs.nixfmt
      ];

      lsp.servers.nixd = {
        enable = true;
        config.settings.nixd = {
          nixpkgs.expr = "import <nixpkgs> { }";
        };
      };

      plugins.conform-nvim.formatters.nix = [ "nixfmt" ];
      plugins.treesitter.grammars = [ "nix" ];
    };
  };
}
