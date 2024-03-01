{ config, pkgs, ... }:
let
  paths = {
    pnpmHome = "${config.xdg.dataHome}/pnpm";
  };
  joinedPath = builtins.concatStringsSep ":" (builtins.attrValues paths);
in
{
  imports = [
    ./starship.nix
    ./zsh.nix
  ];

  # ENV
  home.sessionVariables = {
    EDITOR = "nvim";
    PNPM_HOME = paths.pnpmHome;
    PATH = "$PATH:${joinedPath}";
  };

}
