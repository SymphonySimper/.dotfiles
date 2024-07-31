{ pkgs, ... }:
{
  imports = [
    ./fzf.nix
    ./git.nix
    ./man.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    curl
    eza
    gnutar
    htop
    killall
    ps_mem
    tlrc
    tmux
    trash-cli
    unzip
    wget
    wl-clipboard
    zip
  ];
}
