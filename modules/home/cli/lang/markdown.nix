{ pkgs, lib, ... }:
{
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
