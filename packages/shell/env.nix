{ config, pkgs, ... }:
let
  paths = {
    pnpmHome = "${config.xdg.dataHome}/pnpm";
  };
  joinedPath = builtins.concatStringsSep ":" (builtins.attrValues paths);
in
{
  # ENV
  home.sessionVariables = {
    EDITOR = "nvim";
    PNPM_HOME = paths.pnpmHome;
    CONDARCA = "${xdg.configHome}/conda/condarc";
    PATH = "$PATH:${joinedPath}";
  };
}
