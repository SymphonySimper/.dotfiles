{ ... }: {
  imports = [
    ./helix
    ./git
    ./shell
    ./tmux

    ./bitwarden.nix
    ./btop.nix
    ./chromium.nix
    ./clipboard.nix
    ./direnv.nix
    ./fzf.nix
    ./just.nix
    ./kitty.nix
    ./man.nix
    ./ssh.nix
    ./yazi.nix
  ];
}
