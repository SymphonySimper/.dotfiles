{ my, lib, ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./disko.nix
    ./ideapad.nix
    ./led.nix
    ./logitech.nix
    ./powerManagement.nix
    ./ssd.nix

    ./cpu/amd.nix
    ./gpu/amd.nix
    ./gpu/nvidia.nix
  ];

  my.hardware = {
    audio.enable = lib.mkDefault my.gui.desktop.enable;
    bluetooth.enable = lib.mkDefault false;
    disko.enable = lib.mkDefault false;
    ideapad.enable = lib.mkDefault false;
    led.enable = lib.mkDefault false;
    logitech.enable = lib.mkDefault false;
    powerManagement.enable = lib.mkDefault my.gui.desktop.enable;
    ssd.enable = lib.mkDefault false;

    cpu.amd.enable = lib.mkDefault false;
    gpu = {
      amd.enable = lib.mkDefault false;
      nvidia.enable = lib.mkDefault false;
    };
  };
}
