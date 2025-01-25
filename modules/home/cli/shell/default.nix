{ pkgs, lib, ... }:
{
  imports = [ ./starship.nix ];

  programs = {
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

    fish = {
      enable = true;
      shellInit = # fish
        ''
          set -U fish_greeting # disable greeting
        '';
      interactiveShellInit = # fish
        ''
          set -g fish_key_bindings fish_vi_key_bindings
        '';
    };

    nixvim.plugins = {
      treesitter.grammars = [
        "bash"
        "fish"
      ];
      lsp.servers.bashls.enable = true;
      formatter = {
        packages = [ "shfmt" ];
        ft = {
          sh = "shfmt";
          fish = "fish_indent";
        };
      };
    };
  };

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
