{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./fzf.nix
  ];

  home.packages = with pkgs; [
    zoxide
    fzf
    eza
    trash-cli
    lazygit
    tmux
  ];
}
