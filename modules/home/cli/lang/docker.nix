{ pkgs, lib, ... }:
{
  programs.helix.lsp.docker-langserver.command =
    "${lib.getExe pkgs.dockerfile-language-server-nodejs}";
}
