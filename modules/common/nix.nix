{
  lib,
  config,
  inputs,
  ...
}:
let
  frequency = "weekly";
  system = config.my.common.system;
in
{
  options.my.common = {
    system = lib.mkOption {
      type = lib.types.bool;
    };
  };
  config = {
    nix =
      {
        # Path for pkgs
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        # Garbage Collection
        gc =
          {
            automatic = true;
            options = "--delete-older-than 14d";
          }
          // (
            if system then
              {
                dates = frequency;
              }
            else
              {
                inherit frequency;
              }
          );
      }
      // (
        if system then
          {
            # Strage optimisation
            optimise.automatic = true;

            # Enable flakse
            settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
          }
        else
          { }
      );
  };
}
