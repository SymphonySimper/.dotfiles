{ pkgs, userSettings, ... }:
{
  programs.zellij = {
    enable = userSettings.programs.multiplexer == "zellij";
    enableZshIntegration = true;
    settings = {
      on_force_close = "detach";
      default_shell = "${pkgs.zsh}/bin/zsh";
      simplified_ui = true;
      pane_frames = false;
      default_layout = "compact";
    };
  };
}
