{
  description = "Home Manager configuration of symph";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    # helix-flake.url = "github:helix-editor/helix";
  };

  outputs =
    { nixpkgs
    , home-manager
    , nixos-wsl
    , # helix,
      ...
    }:
    let
      profileSettings = {
        name = "wsl";
        system = "x86_64-linux";
      };
      userSettings = {
        username = "symph";
      };
      pkgs = nixpkgs.legacyPackages.${profileSettings.system};
      lib = nixpkgs.lib;
    in
    {
      homeConfigurations.${userSettings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./profiles/${profileSettings.name}/home.nix ];

        extraSpecialArgs = {
          inherit userSettings;
          inherit profileSettings;
          # helix-flake = helix;
        };
      };
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = profileSettings.system;
          modules = [ ./profiles/${profileSettings.name}/configuration.nix ];
          specialArgs = {
            # pass config variables from above
            inherit pkgs;
            inherit userSettings;
            inherit profileSettings;
            nixos-wsl = nixos-wsl;
          };
        };
      };
    };
}
