{ pkgs, ... }:
{
  mkKeymaps = import ./mkKeymaps.nix;
  mkNotification = (import ./mkNotification.nix { inherit pkgs; });
}
