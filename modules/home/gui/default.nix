{ my, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./browser.nix
    ./music.nix
    ./office.nix
    ./theme.nix
    ./video.nix

    ./desktop
  ];

  my.programs = {
    browser.enable = lib.mkDefault my.gui.enable;
    music.enable = lib.mkDefault my.gui.enable;
    office.enable = lib.mkDefault my.gui.enable;
    video.enable = lib.mkDefault my.gui.enable;
  };
}
