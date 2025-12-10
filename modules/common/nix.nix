{
  my,
  inputs,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.nix;

    # Path for pkgs
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # Garbage Collection
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      dates = "weekly";
    };

    settings = {
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
      nixpkgs.flake = inputs.nixpkgs;
      my.flake = inputs.self;
    };
  };
}
