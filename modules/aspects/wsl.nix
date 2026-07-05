{
  flake-file.inputs.nixos-wsl = {
    url = "github:nix-community/nixos-wsl";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.wsl = {
    nixos =
      {
        config,
        lib,
        ...
      }:
      let
        cfg = config.wsl;
      in
      {
        options.wsl = {
          appendPath = lib.mkEnableOption "Append windows path";
        };

        config = {
          wsl = {
            enable = true;
            interop.includePath = cfg.appendPath;
            startMenuLaunchers = false;

            wslConf = {
              user.default = cfg.defaultUser;

              interop = {
                enabled = true;
                appendWindowsPath = cfg.appendPath;
              };
            };
          };
        };
      };

    homeManager = { pkgs, ... }: {
      services.ssh-agent.enable = true;

      programs = {
        helix.settings.editor.clipboard-provider = "win32-yank";

        nushell.settings.shell_integration.osc9_9 = true;
        fish.functions = {
          _windows_terminal_wsl_path = {
            onVariable = "PWD";
            body = ''
              if test -n "$WT_SESSION"
                printf "\e]9;9;%s\e\\" (string replace --all '/' '\\' "\\\\wsl.localhost\\$WSL_DISTRO_NAME$PWD")
              end
            '';
          };
        };

        tmux.terminal = "xterm-256color";
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
    };
  };
}
