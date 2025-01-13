{ pkgs, ... }:
{
  my.programs.nvim = {
    treesitter = [
      "toml"
      "yaml"
    ];
    lsp = {
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
