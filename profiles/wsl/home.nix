{ config, ... }:
let
  cfgSh = config.my.programs.shell;

  path = {
    programFiles = "/mnt/c/Program Files";
    system32 = "/mnt/c/windows/system32";
  };
in
{
  my.programs = {
    shell.addToPath = {
      "win32yank.exe" = "${path.programFiles}/Neovim/bin/win32yank.exe";
    };

    editor.clipboardProvider = "win32-yank";

    terminal.runScriptContent = # sh
      ''
        user_dir=$(wslpath $(${path.system32}/cmd.exe /c "echo %USERPROFILE%" 2>/dev/null) | tr -d "\r")

        exec "$user_dir/AppData/Local/Microsoft/WindowsApps/wt.exe" \
          --window 0 --profile "NixOS" \
          ${cfgSh.command} ${cfgSh.args.command} "$*"
      '';

  };
}
