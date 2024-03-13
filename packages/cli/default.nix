{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./fzf.nix
    ./git.nix
    ./man.nix
    ./tmux.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    curl
    eza
    gnutar
    htop
    killall
    lazygit
    ps_mem
    tlrc
    tmux
    trash-cli
    unzip
    wget
    zip
  ];
}
