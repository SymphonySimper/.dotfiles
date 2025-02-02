{ pkgs, lib, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "markdown" ];

    formatter = {
      packages = [ pkgs.nodePackages.prettier ];
      ft.markdown = "prettier";
    };
  };

  programs.helix = {
    grammars = [ "markdown" ];

    lsp.marksman.command = "${lib.getExe pkgs.marksman}";
    language = [
      {
        name = "markdown";
        formatter = {
          command = "${lib.getExe pkgs.nodePackages.prettier}";
          args = [
            "--parser"
            "markdown"
          ];
        };
      }
    ];
  };
}
