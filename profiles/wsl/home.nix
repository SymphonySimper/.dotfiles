{ pkgs, ... }:
{
  my.programs = {
    work.enable = true;
    editor.settings.editor.clipboard-provider = "win32-yank";
  };

  home.packages = [
    (pkgs.stdenv.mkDerivation rec {
      pname = "win32yank";
      version = "0.1.1";

      src = pkgs.fetchzip {
        url = "https://github.com/equalsraf/win32yank/releases/download/v${version}/win32yank-x64.zip";
        sha256 = "sha256-4ivE1cYZhYs4ibx5oiYMOhbse9bdOomk7RjgdVl5lD0=";
        stripRoot = false;
      };

      installPhase = ''
        mkdir -p $out/bin
        cp win32yank.exe $out/bin
        chmod +x $out/bin/*
      '';
    })

    (pkgs.writeShellScriptBin "xdg-open" ''
      # based on: /mnt/c/Program Files/Git/usr/bin/start
      arg=$1

      if [ -e "$arg" ]; then
        path=$(wslpath -w "$arg")
      else
        path=''${arg//&/^&}
      fi

      '/mnt/c/Program Files/PowerShell/7/pwsh.exe' -Command start "$path"
    '')
  ];

  services.ssh-agent.enable = true;
}
