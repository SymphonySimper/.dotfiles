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
    jq
    killall
    tlrc # tldr
    trash-cli
    unzip
    wget
    wl-clipboard
    zip
  ];
}
