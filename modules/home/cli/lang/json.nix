{ ... }:
{
  my.programs.nvim = {
    treesitter = [ "json" ];
    lsp.jsonls.enable = true;
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
}
