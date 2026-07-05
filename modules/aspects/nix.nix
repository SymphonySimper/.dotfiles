{
  inputs,
  self,
  den,
  ...
}:
{
  den.default.includes = [ den.aspects.nix ];

  den.aspects.nix =
    let
      nixpkgs = inputs.nixpkgs;

      mkNix = users: {
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

          trusted-users = users;
          show-trace = true;
          auto-optimise-store = true;

          # Enable flakes
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          commit-lock-file-summary = "chore(flake): update flake.lock";
        };

        registry = {
          nixpkgs.flake = nixpkgs;
          my.flake = self;
        };
      };
    in
    {
      nixos = { config, ... }: {
        nix = mkNix config.users.groups.wheel.members;
      };
      homeManager = {
        nix = mkNix [ ];
      };
    };
}
