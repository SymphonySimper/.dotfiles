{ userSettings, ... }:
{
  imports = [
    ../../home/default.nix
    ../../home/packages/gui/default.nix
  ] ++ (if userSettings.programs.wm then [
    ../../home/packages/wm/default.nix
  ] else [ ]);
}
