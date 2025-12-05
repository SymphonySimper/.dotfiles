{ config, pkgs, ... }:
let
  cfgSh = config.my.programs.shell;

  path = {
    programFiles = "/mnt/c/Program Files";
    system32 = "/mnt/c/windows/system32";
  };
in
{
  my.programs = {
    editor.clipboardProvider = "win32-yank";

    # NOTE: profile option is just for other settings not starting shell
    terminal.runScriptContent = # sh
      ''
        user_dir=$(wslpath $(${path.system32}/cmd.exe /c "echo %USERPROFILE%" 2>/dev/null) | tr -d "\r")

        exec "$user_dir/AppData/Local/Microsoft/WindowsApps/wt.exe" \
          --window 0 \
          --profile "NixOS" wsl.exe -d NixOS --cd ~ ${cfgSh.command} ${cfgSh.args.login} ${cfgSh.args.command} "$*"
      '';
  };

  home.packages = [
    (pkgs.stdenv.mkDerivation rec {
      pname = "win32yank";
      version = "0.1.1";

      src = pkgs.fetchzip {
        url = "https://github.com/equalsraf/win32yank/releases/download/${version}/win32yank-x64.zip";
        sha256 = "sha256-4ivE1cYZhYs4ibx5oiYMOhbse9bdOomk7RjgdVl5lD0=";
        stripRoot = false;
      };

      installPhase = ''
        mkdir -p $out/bin
        cp win32yank.exe $out/bin
        chmod +x $out/bin/*
      '';
    })
  ];

  services.ssh-agent.enable = true;
}
