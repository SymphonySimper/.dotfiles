{
  description = "Home Manager configuration of symph";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # helix-flake.url = "github:helix-editor/helix";
  };

  outputs =
    { nixpkgs
    , home-manager
    , # helix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      profile = "default";
      userSettings = {
        username = "symph";
      };
    in
    {
      homeConfigurations.${userSettings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./profiles/${profile}/home.nix ];

        extraSpecialArgs = {
          inherit userSettings;
          # helix-flake = helix;
        };
      };
    };
}
