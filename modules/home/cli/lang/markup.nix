{ pkgs, lib, ... }:
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

  programs.helix = {
    grammars = [
      "toml"
      "yaml"
    ];

    language = [
      {
        name = "toml";
        formatter = {
          command = "${lib.getExe pkgs.taplo}";
          args = [
            "format"
            "-"
          ];
        };
      }
      {
        name = "yaml";
        formatter = {
          command = "${lib.getExe pkgs.nodePackages.prettier}";
          args = [
            "--parser"
            "yaml"
          ];
        };
      }
    ];
  };
}
