{ pkgs, lib, ... }:
{
  programs = {
    jq.enable = true;

    nixvim.plugins = {
      treesitter.grammars = [ "json" ];

      lsp.servers.jsonls.enable = true;

      formatter = {
        packages = [
          "biome"
        ];
        ft = rec {
          json = "biome";
          jsonc = json;
        };
      };
    };

    helix = {
      grammars = [
        "json"
        "jsonc"
      ];

      language =
        builtins.map
          (name: {
            inherit name;
            formatter = {
              command = "${lib.getExe pkgs.nodePackages.prettier}";
              args = [
                "--parser"
                name
              ];
            };
          })
          [
            "json"
            "jsonc"
          ];
    };
  };
}
