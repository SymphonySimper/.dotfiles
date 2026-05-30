{
  my,
  config,
  inputs,
  pkgs,
  ...
}:
let
  nixpkgs = if config.my.isHome then inputs.nixpkgs-unstable else inputs.nixpkgs-nixos-unstable;
in
{
  nix = {
    package = pkgs.nix;

    # Path for pkgs
    nixPath = [ "nixpkgs=${nixpkgs}" ];

    # Garbage Collection
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      dates = "weekly";
    };

    settings = {
      connect-timeout = 60; # seconds

      show-trace = true;
      auto-optimise-store = true;
      trusted-users = [
        "root"
        my.name
      ];

      # Enable flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      commit-lock-file-summary = "chore(flake): update flake.lock";
    };

    registry = {
      nixpkgs.flake = nixpkgs;
      my.flake = inputs.self;
    };
  };
}
