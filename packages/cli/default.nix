{ config, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./fzf.nix
    ./git.nix
    ./tmux.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    eza
    trash-cli
    lazygit
    tmux
  ];
}
