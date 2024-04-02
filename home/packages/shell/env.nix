{ config, ... }:
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
    # CONDARCA = "${config.xdg.configHome}/conda/condarc";
    MAMBA_ROOT_PREFIX = "${config.xdg.dataHome}/mamba";
    PATH = "$PATH:${joinedPath}";
    ZELLIJ_AUTO_EXIT = "true";
    #  WLR_NO_HARDWARE_CURSORS = "1";
    #  NIXOS_OZONE_WL = "1";
  };
}
