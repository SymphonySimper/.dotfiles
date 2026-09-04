{ config, lib, ... }:
let
  cfg = config.programs;
in
{
  options.home.shell.interactive = lib.mkOption {
    type = lib.types.str;
    readOnly = true;
    description = "Interactive Shell";
    default = lib.getExe (if cfg.fish.enable then cfg.fish.package else cfg.bash.package);
  };
}
