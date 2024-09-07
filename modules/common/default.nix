{ lib, pkgs, ... }:
{
  imports = [ ./config.nix ];
  # lib = lib.extend (self: super: { my = (import ./lib/default.nix { inherit pkgs; }); });
}
