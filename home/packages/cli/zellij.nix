{ pkgs, ... }:
{
  programs.zellij = {
    enable = false;
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
