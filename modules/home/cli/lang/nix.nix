{
  inputs,
  pkgs,
  lib,
  config,
  my,
  ...
}:
{
  options.my.programs.nixpkgs-update.enable = lib.mkEnableOption "nixpkgs-update";
  config = {
    home = {
      shellAliases = {
        snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake";
        nix_flake_update = "nix flake update --commit-lock-file";
        hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake";
      };

      packages = lib.optionals config.my.programs.nixpkgs-update.enable [
        inputs.nixpkgs-update.packages.${my.system}.nixpkgs-update
        pkgs.tree
      ];
    };
  };
}
