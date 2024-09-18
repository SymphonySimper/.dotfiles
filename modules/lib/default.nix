{ pkgs, ... }:
{
  mkKeymaps = import ./mkKeymaps.nix;
  mkNotification = (import ./mkNotification.nix { inherit pkgs; });
  mkTTYLaunch = (import ./mkTTYLaunch.nix { inherit pkgs; });
  mkSystemdTimer = import ./mkSystemdTimer.nix;
}
