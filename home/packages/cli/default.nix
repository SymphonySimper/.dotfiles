{ pkgs, ... }:
{
  imports = [
    ./btop.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./htop.nix
    ./man.nix
    ./multiplexer/default.nix
    ./ripgrep.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    curl
    gnutar
    killall
    ps_mem
    tlrc # tldr
    trash-cli
    unzip
    wget
    wl-clipboard
    zip
  ];
}
