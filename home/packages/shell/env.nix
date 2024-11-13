{ userSettings, config, ... }:
let
  paths = {
    pnpmHome = "${config.xdg.dataHome}/pnpm";
  };
  joinedPath = builtins.concatStringsSep ":" (builtins.attrValues paths);
in
{
  # ENV
  home.sessionVariables = {
    EDITOR = userSettings.programs.editor;
    PNPM_HOME = paths.pnpmHome;
    # CONDARCA = "${config.xdg.configHome}/conda/condarc";
    MAMBA_ROOT_PREFIX = "${config.xdg.dataHome}/mamba";
    PATH = "$PATH:${joinedPath}";
    #  WLR_NO_HARDWARE_CURSORS = "1";
    #  NIXOS_OZONE_WL = "1";
  };
}
