{ config, lib, ... }:
let
  cfg = config.programs;
  shell = lib.getExe (if cfg.fish.enable then cfg.fish.package else cfg.bash.package);
in
{
  programs.kitty.settings.shell = shell;
  programs.tmux.shell = shell;
}
