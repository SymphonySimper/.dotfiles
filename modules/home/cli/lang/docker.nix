{ pkgs, lib, ... }:
{
  programs.nixvim.plugins.treesitter.grammars = [
    "dockerfile"
  ];

  programs.helix = {
    grammars = [ "dockerfile" ];
    lsp.docker-langserver.command = "${lib.getExe pkgs.dockerfile-language-server-nodejs}";
  };
}
