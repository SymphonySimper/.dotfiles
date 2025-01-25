{ pkgs, lib, ... }:
{
  imports = [ ./starship.nix ];

  programs.bash = {
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
