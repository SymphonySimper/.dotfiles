{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./fzf.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    eza
    trash-cli
    lazygit
    tmux
  ];
}
