{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [
      "toml"
      "yaml"
    ];

    conform-nvim = {
      formatter.taplo = pkgs.taplo;
      settings.formatters_by_ft = {
        yaml = [ "prettier" ];
        toml = [ "taplo" ];
      };
    };

    lsp.servers = {
      yamlls.enable = true;
      # TOML
      taplo.enable = true;
    };
  };
}
