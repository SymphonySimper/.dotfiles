{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./bash.nix
    ./starship.nix
    ./zsh.nix
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
