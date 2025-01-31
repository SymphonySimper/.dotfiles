{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "markdown" ];

    formatter = {
      packages = [ pkgs.nodePackages.prettier ];
      ft.markdown = "prettier";
    };
  };
}
