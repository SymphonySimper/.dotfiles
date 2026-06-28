{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ./audio.nix
    ./bluetooth.nix
    ./cpu.nix
    ./disko.nix
    ./gpu.nix
    ./led.nix
    ./logitech.nix
    ./powerManagement.nix
    ./ssd.nix
  ];
}
