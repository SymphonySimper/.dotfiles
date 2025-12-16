{ pkgs, ... }:
{
  my.programs = {
    shell.setTerminalTitle = true;
    editor.clipboardProvider = "win32-yank";
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
