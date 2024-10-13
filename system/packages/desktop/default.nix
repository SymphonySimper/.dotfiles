{ userSettings, ... }:
{
  imports = [
    ../../packages/steam.nix
    ../../packages/chromium.nix
  ] ++ (if userSettings.desktop.wm then [ ./wm/default.nix ] else [ ./de/default.nix ]);

  my.programs.steam.enable = userSettings.desktop.steam;
}
