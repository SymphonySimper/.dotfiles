{ config, ... }:
{
  my.programs = {
    shell.addToPath =
      let
        programFiles = "/mnt/c/Program Files";
        terminal = config.my.programs.terminal.command;
      in
      {
        "win32yank.exe" = "${programFiles}/Neovim/bin/win32yank.exe";
        ${terminal} = "${programFiles}/${terminal}/${terminal}.exe";
      };

    editor.clipboardProvider = "win32-yank";
  };
}
