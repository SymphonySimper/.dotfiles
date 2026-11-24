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
    ./discord.nix
    ./fd.nix
    ./fzf.nix
    ./hex.nix
    ./just.nix
    ./kitty.nix
    ./man.nix
    ./ripgrep.nix
    ./ssh.nix
    ./yazi.nix
  ];
}
