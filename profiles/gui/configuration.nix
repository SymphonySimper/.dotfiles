{ ... }:
{
  imports = [
    ../../system/default.nix
    ../../system/packages/gnome.nix
    ../../system/packages/nvidia.nix
    ../../system/pc.nix
    ./hardware.nix
  ];
}
