{ my, lib, ... }:
{
  imports = [
    ./browser.nix
    ./desktop.nix
    ./kanata.nix
    ./steam.nix

    ./vm
  ];

  my.programs = {
    browser.enable = lib.mkDefault my.gui.enable;
    steam.enable = lib.mkDefault false;

    vm = {
      enable = lib.mkDefault false;
      waydroid.enable = lib.mkDefault false;
    };
  };
}
