{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [
      "toml"
      "yaml"
    ];

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
