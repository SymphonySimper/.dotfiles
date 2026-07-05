{ den, lib, ... }: {
  flake-file = {
    inputs.home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixConfig = {
      extra-substituters = [ "https://nix-community.cachix.org?priority=2" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default.includes = [ den.aspects.home-manager ];

  den.aspects.home-manager = {
    nixos = {
      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
      };
    };

    homeManager = {
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
    };
  };
}
