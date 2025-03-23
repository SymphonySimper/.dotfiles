{ lib, ... }:
{
  imports = [
    ./browser.nix
    ./desktop.nix
    ./kanata.nix
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
