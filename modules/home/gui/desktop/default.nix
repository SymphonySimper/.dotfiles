{ my, lib, ... }:
{
  imports = (
    lib.optionals my.gui.desktop.enable ([ ./services ] ++ (lib.optionals my.gui.desktop.wm [ ./wm ]))
  );
}
