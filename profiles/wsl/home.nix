{ config, pkgs, ... }:
let
  programFiles = "/mnt/c/Program\\ Files";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "win32yank.exe" ''
      exec ${programFiles}/Neovim/bin/win32yank.exe  "''${@}"
    '')

    (
      let
        command = config.my.programs.terminal.command;
      in
      pkgs.writeShellScriptBin "${command}" ''exec ${programFiles}/${command}/${command}.exe  "''${@}" ''
    )
  ];

  my.programs.editor.clipboardProvider = "win32-yank";
}
