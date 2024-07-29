{ userSettings, ... }:
{
  imports = (if userSettings.programs.wm then [ ./wm/default.nix ] else [ ./de/default.nix ]);
}
