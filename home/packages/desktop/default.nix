{ my, ... }:
{
  imports = [
    ./services/default.nix
  ] ++ (if my.gui.desktop.wm then [ ./wm/default.nix ] else [ ]);
}
