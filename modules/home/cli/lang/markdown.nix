{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "markdown" ];

    lsp.servers.marksman.enable = true;

    formatter = {
      packages = [ pkgs.nodePackages.prettier ];
      ft.markdown = "prettier";
    };
  };
}
