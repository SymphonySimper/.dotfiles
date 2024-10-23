{
  inputs,
  system ? throw "Set sytstem to true for NixOS and false for Home Manager",
  ...
}:
let
  frequency = "weekly";
in
{
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
        }
      else
        { }
    );
}
