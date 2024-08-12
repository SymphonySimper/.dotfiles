{ userSettings, ... }:
{
  imports = (if userSettings.desktop.wm then [ ./wm/default.nix ] else [ ]);
}
