{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "catppuccin-mocha";
      on_force_close = "detach";
      simplified_ui = true;
      default_shell = "${pkgs.zsh}/bin/zsh";
      default_layout = "compact";
    };
  };
}
