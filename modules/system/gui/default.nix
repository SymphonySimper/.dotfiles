{ lib, ... }:
{
  imports = [
    ./desktop.nix
    ./keyboard.nix
    ./steam.nix

    ./vm
  ];

  my.programs = {
    steam.enable = lib.mkDefault false;

    vm = {
      enable = lib.mkDefault false;
      waydroid.enable = lib.mkDefault false;
    };
  };
}
