{ config, lib, ... }:
let
  cfg = config.programs.tmux;
in
{
  options.programs.tmux = {
    enableTerminalAutoLaunch = lib.mkEnableOption "Terminal Auto Launch";
  };

  config = {
    # RGB colors
    # https://github.com/tmux/tmux/wiki/FAQ#how-do-i-use-rgb-colour
    programs.tmux.extraConfig = ''
      set -as terminal-features ",${cfg.terminal}:RGB"
    '';

    programs.kitty.settings.shell = lib.mkIf cfg.enableTerminalAutoLaunch (
      lib.mkForce (lib.getExe cfg.package)
    );
  };
}
