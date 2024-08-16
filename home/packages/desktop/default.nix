{ userSettings, ... }:
{
  imports = [
    ./services/default.nix
  ] ++ (if userSettings.desktop.wm then [ ./wm/default.nix ] else [ ]);
}
