{ ... }:
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
  };
}
