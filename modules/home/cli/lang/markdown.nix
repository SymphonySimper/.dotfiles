{ pkgs, lib, ... }:
{
  programs.helix = {
    lsp.markdown-oxide.command = "${lib.getExe pkgs.markdown-oxide}";
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
