{ inputs, den, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  flake-file = {
    inputs = {
      den.url = "github:denful/den";
      flake-file.url = "github:vic/flake-file";
    };

    nixConfig = {
      extra-substituters = [ "https://cache.nixos.org?priority=1" ];
      extra-trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };

  den.default.includes = [
    den.batteries.inputs'
    den.batteries.self'
  ];
}
