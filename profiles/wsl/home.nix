{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "win32yank.exe" ''
      /mnt/c/Program\ Files/Neovim/bin/win32yank.exe  "''${@}"
    '')
  ];

  my.programs.editor.clipboardProvider = "win32-yank";
}
