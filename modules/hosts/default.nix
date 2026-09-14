{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;

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

  mkConfigs = type: builtins.mapAttrs (_: value: mkConfig (value // { inherit type; }));

  nixosHosts = {
    laptop = {
      system = "x86_64-linux";
      modules = [ ./laptop/nixos.nix ];
    };
  };

  homeHosts = {
    laptop = {
      system = "x86_64-linux";
      modules = [ ./laptop/home.nix ];
    };
  };

  systems = lib.unique (
    (map (host: host.system) (lib.attrValues nixosHosts))
    ++ (map (host: host.system) (lib.attrValues homeHosts))
  );
in
{
  inherit mkConfig systems;

  nixosConfigurations = mkConfigs "nixos" nixosHosts;
  homeConfigurations = mkConfigs "home" homeHosts;
}
