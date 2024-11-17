{ lib, my, ... }:
{
  config = lib.mkIf my.gui.enable { programs.obs-studio.enable = true; };
}
