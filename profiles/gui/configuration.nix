{ ... }:
{
  imports = [
    ../../system/default.nix
    ../../system/hardware/ideapad.nix
    ../../system/packages/gnome.nix
    ../../system/packages/nvidia.nix
    ../../system/pc.nix
    ./hardware.nix
  ];
}
