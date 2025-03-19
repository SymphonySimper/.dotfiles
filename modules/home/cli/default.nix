{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
    ./nix.nix
    ./ssh.nix
    ./tmux.nix
    ./top.nix
    ./yazi.nix
    ./zoxide.nix

    ./helix
    ./scripts
    ./shell
  ];

  home.packages = with pkgs; [
    bc
    curl
    gnutar
    killall
    tlrc # tldr
    trash-cli
    unzip
    wget
    wl-clipboard
    zip
  ];

  programs = {
    man = {
      enable = true;
      generateCaches = true;
    };

    fzf = {
      enable = true;
      defaultOptions = [
        "--reverse"
      ];
    };

    fd.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };
}
