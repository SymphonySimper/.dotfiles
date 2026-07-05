{ den, lib, ... }: {
  den.hosts.x86_64-linux.laptop = {
    users.symph = { };
  };

  den.aspects.laptop = {
    includes = with den.aspects; [
      den.batteries.hostname

      boot

      hardware.disko
      hardware.disable-fn-led

      networking.dns.cloudflare
    ];

    nixos = {
      hardware.disko = {
        disk = "/dev/nvme0n1";
        swap = "16G";
      };

      hardware.facter.reportPath = ./facter.json;
      hardware.logitech.wireless.enable = true;

      # refer: https://gitlab.freedesktop.org/drm/amd/-/issues/3647
      # prevents system freeze
      boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];
    };

    symph = {
      includes = with den.aspects; [
        apps.shell.fish
        (den.batteries.user-shell "fish")

        desktop.gnome
        desktop.gnome.extension
        apps.chromium
        theme.fonts
        apps.kitty

        apps.shell.nushell

        scripts.todo
        scripts.ocr
        scripts.ffmpeg

        apps.yazi
        apps.btop
        apps.fzf
        apps.just
        apps.tmux
        apps.git
        apps.ssh

        apps.lang.config
        apps.lang.english
        apps.lang.go
        apps.lang.markdown
        apps.lang.nix
        apps.lang.python
        apps.lang.rust
        apps.lang.tree-sitter
        apps.lang.web
      ];

      homeManager = { pkgs, ... }: {
        programs.yazi.preview = true;

        programs.gh = {
          enable = true;
          settings.git_protocol = "ssh";
        };

        home.packages = [
          pkgs.libreoffice

          (pkgs.writeShellScriptBin "mynixpkgsreview" ''
            pr_id="$1"

            if [ -z "$1" ]; then
              echo "Requires PR ID (ex: 481226)."
              exit 1
            fi

            ${lib.getExe' pkgs.nixpkgs-review "nixpkgs-review"} pr --post-result "$pr_id"
          '')
        ];
      };
    };
  };
}
