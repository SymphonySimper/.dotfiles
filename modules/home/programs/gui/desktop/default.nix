{ config, ... }:
{
  imports = [
    ./services/default.nix
    ./wm/default.nix
  ];
}
