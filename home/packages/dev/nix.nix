{ ... }:
{
  home.shellAliases = {
    snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake";
    nix_flake_update = "nix flake update --commit-lock-file";
    hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake";
  };
}
