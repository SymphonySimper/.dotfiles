{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "win32yank.exe" ''
      /mnt/c/Program\ Files/Neovim/bin/win32yank.exe  "''${@}"
    '')

    (
      let
        command = config.my.programs.terminal.command;
      in
      pkgs.writeShellScriptBin "${command}" ''/mnt/c/Program\ Files/${command}/${command}.exe  "''${@}" ''
    )
  ];

  my.programs.editor.clipboardProvider = "win32-yank";
}
