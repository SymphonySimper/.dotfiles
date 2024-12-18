{ pkgs, ... }:
{
  imports = [
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./man.nix
    ./ripgrep.nix
    ./ssh.nix
    ./tmux.nix
    ./top.nix
    ./yazi.nix
    ./zoxide.nix

    ./lang
    ./nvim
    ./scripts
    ./shell
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
