{ modulesPath, lib, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ./audio.nix
    ./bluetooth.nix
    ./cpu.nix
    ./disko.nix
    ./gpu.nix
    ./ideapad.nix
    ./input.nix
    ./led.nix
    ./powerManagement.nix
    ./ssd.nix
  ];

  my.hardware = {
    audio.enable = lib.mkDefault false;
    bluetooth.enable = lib.mkDefault false;
    disko.enable = lib.mkDefault false;
    ideapad.enable = lib.mkDefault false;
    keyboard.enable = lib.mkDefault false;
    led.enable = lib.mkDefault false;
    logitech.enable = lib.mkDefault false;
    powerManagement.enable = lib.mkDefault false;
    ssd.enable = lib.mkDefault false;

    cpu = {
      amd.enable = lib.mkDefault false;
      intel.enable = lib.mkDefault false;
    };

    gpu = {
      amd.enable = lib.mkDefault false;
      intel.enable = lib.mkDefault false;
      nvidia.enable = lib.mkDefault false;
    };
  };
}
