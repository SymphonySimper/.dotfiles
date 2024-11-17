{ my, ... }:
{
  imports =
    if my.gui.desktop.enable then
      [ ./services ] ++ (if my.gui.desktop.wm then [ ./wm ] else [ ])
    else
      [ ];
}
