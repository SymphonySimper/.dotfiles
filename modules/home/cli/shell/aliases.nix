{ lib, pkgs, ... }:
{
  home.shellAliases = {
    # general
    q = "exit";
    ka = "killall";
    ## misc
    im_light = "${lib.getExe pkgs.ps_mem} -p $(pgrep -d, -u $USER)";

    # dev
    ## docker
    docker_cln = "docker system prune --volumes";
  };
}
