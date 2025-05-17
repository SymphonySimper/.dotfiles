{ pkgs, ... }:
{
  imports = [
    ./file-manager.nix
    ./mux.nix
    ./nix.nix
    ./ssh.nix
    ./top.nix
    ./vcs.nix

    ./editor
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
