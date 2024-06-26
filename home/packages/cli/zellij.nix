{ pkgs, userSettings, ... }:
{
  programs.zellij = {
    enable = userSettings.programs.zellij;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      on_force_close = "detach";
      default_shell = "${pkgs.zsh}/bin/zsh";
      simplified_ui = true;
      pane_frames = false;
      default_layout = "compact";
    };
  };
}
