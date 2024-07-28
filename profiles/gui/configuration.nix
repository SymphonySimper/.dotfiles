{ inputs, ... }:
{
  imports = [
    # ../../system/hardware/ideapad.nix
    # ../../system/packages/nvidia/enable.nix
    (import ../../system/hardware/disko.nix {
      inherit inputs;
      device = "/dev/nvme0n1";
      swap = "16G";
    })
    ../../system/default.nix
    ../../system/packages/steam.nix
    # ../../system/packages/vm.nix
    ../../system/pc.nix
    ./hardware.nix
    ../../system/packages/wm/default.nix
  ];

  services.xserver.videoDrivers = [ "amdgpu" ];
}
