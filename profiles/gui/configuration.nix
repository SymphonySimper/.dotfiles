{ inputs, ... }:
{
  imports = [
    # ../../system/hardware/ideapad.nix
    # ../../system/packages/nvidia/enable.nix
    # ../../system/packages/vm.nix
    (import ../../system/hardware/disko.nix {
      inherit inputs;
      device = "/dev/nvme0n1";
      swap = "16G";
    })
    ../../system/default.nix
    ../../system/hardware/logitech.nix
    ../../system/packages/desktop/default.nix
    ../../system/pc.nix
    ./hardware.nix
  ];
}
