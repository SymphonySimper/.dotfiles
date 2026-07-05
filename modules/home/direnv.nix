{ config, lib, ... }:
let
  cfg = config.my.programs.direnv;
in
{
  options.my.programs.direnv.enable = lib.mkEnableOption "Enable Direnv";

  my.programs.editor.ignore = [
    # direnv
    "!.envrc"
    ".direnv"
  ];

  direnv = lib.mkIf cfg.enable {
    enable = true;
    nix-direnv.enable = true;

    silent = false;
    config.warn_timeout = "2m";
  };
}
