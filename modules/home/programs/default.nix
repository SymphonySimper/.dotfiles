{ ... }: {
  imports = [
    ./git
    ./nixvim
    ./shell
    ./tmux

    ./bitwarden.nix
    ./btop.nix
    ./chromium.nix
    ./clipboard.nix
    ./direnv.nix
    ./fd.nix
    ./fzf.nix
    ./just.nix
    ./kitty.nix
    ./man.nix
    ./ripgrep.nix
    ./ssh.nix
    ./yazi.nix
  ];
}
