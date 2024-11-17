{ my, ... }:
{
  imports = [
    ../../packages/steam.nix
    ../../packages/chromium.nix
  ] ++ (if my.gui.desktop.wm then [ ./wm/default.nix ] else [ ./de/default.nix ]);

  my.programs.steam.enable = false;
}
