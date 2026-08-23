{ inputs, ... }:
let
  mkConfig =
    {
      type, # nixos, home
      modules,
      system ? "x86_64-linux",
    }:
    let
      specialArgs = {
        inherit inputs;
        inherit (inputs) self;
      };
    in
    if type == "nixos" then
      inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs system;
        modules = [ ../nixos ] ++ modules;
      }
    else if type == "home" then
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = specialArgs;
        modules = [ ../home ] ++ modules;
      }
    else
      throw "unsupported configuration type: ${type}";
in
{
  inherit mkConfig;

  nixosConfigurations = builtins.mapAttrs (_: value: mkConfig (value // { type = "nixos"; })) {
    laptop.modules = [ ./laptop/nixos.nix ];
  };

  homeConfigurations = builtins.mapAttrs (_: value: mkConfig (value // { type = "home"; })) {
    laptop.modules = [ ./laptop/home.nix ];
  };
}
