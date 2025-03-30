{ pkgs, lib, ... }:
{
  imports = [ ./prompt.nix ];

  programs = lib.mkMerge [
    {
      bash = {
        enable = true;
        enableCompletion = true;
        shellOptions = [
          "autocd" # cd when directory
        ];

        profileExtra = # sh
          ''
            # nix_loc="$HOME"/.nix-profile/etc/profile.d/nix.sh
            # [ -f $nix_loc ] && . $nix_loc

            . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          '';
      };

      readline = {
        enable = true;
        variables = {
          editing-mode = "vi";
          completion-ignore-case = true;
          show-all-if-ambiguous = true;
        };
        bindings = {
          "\\C-l" = "clear-screen";
        };
      };

      helix.lsp.bash-language-server = {
        command = "${lib.getExe pkgs.bash-language-server}";
        environment.SHFMT_PATH = "${lib.getExe pkgs.shfmt}";
      };
    }

    {
      direnv = {
        enable = true;
        nix-direnv.enable = true;

        silent = true;
        config.warn_timeout = "2m";
      };

      helix.ignore = [
        "!.envrc"
        ".direnv"
      ];
    }

    {
      zoxide = {
        enable = true;
        enableBashIntegration = false;
      };

      bash.initExtra =
        lib.mkOrder 2000 # sh
          ''
            eval "$(${lib.getExe pkgs.zoxide} init bash)"    
          '';
    }
  ];

  home.shellAliases = rec {
    # general
    q = "exit";
    ka = "killall";
    ## ls
    ls = "ls --almost-all --color=yes --group-directories-first --human-readable";
    lsl = "${ls} -l --size";
    ## misc
    im_light = "${lib.getExe pkgs.ps_mem} -p $(pgrep -d, -u $USER)";
  };
}
