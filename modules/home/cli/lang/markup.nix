{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [
      "toml"
      "yaml"
    ];

    lsp.servers = {
      taplo.enable = true; # TOML
      yamlls.enable = true;
    };

    formatter = {
      packages = [
        "taplo"
        pkgs.nodePackages.prettier
      ];
      ft = {
        toml = "taplo";
        yaml = "prettier";
      };
    };
  };
}
