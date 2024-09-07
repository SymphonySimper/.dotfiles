{ pkgs, config, ... }:
{
  imports = [
    # cli
    ./btop.nix
    ./eza.nix
    ./fd.nix
    ./fzf.nix
    ./git.nix
    ./htop.nix
    ./man.nix
    ./nvim/default.nix
    ./ripgrep.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./zoxide.nix
    ./sh.nix

    # lang
    ./go.nix
    ./js.nix
    ./python.nix
    ./rust.nix

    # scripts
    ./scripts/default.nix
  ];

  home.packages =
    with pkgs;
    [
      curl
      gcc
      gnumake
      gnutar
      google-cloud-sdk
      jq
      killall
      ps_mem
      tlrc # tldr
      trash-cli
      unzip
      wget
      wl-clipboard
      zip
    ]
    ++ (if config.my.gui.enable then [ vscode-fhs ] else [ ]);
}
