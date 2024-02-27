{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    zoxide
    fzf
    eza
    trash-cli
    lazygit
    tmux
  ];
}
