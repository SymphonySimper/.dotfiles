{ my, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./browser.nix
    ./office.nix
    ./theme.nix
    ./video.nix

    ./desktop
  ];

  my.programs = {
    browser.enable = lib.mkDefault my.gui.enable;
    office.enable = lib.mkDefault my.gui.enable;
    video.enable = lib.mkDefault my.gui.enable;
  };
}
