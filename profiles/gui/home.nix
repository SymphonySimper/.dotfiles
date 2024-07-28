{ userSettings, ... }:
{
  imports = [
    ../../home/default.nix
    ../../home/packages/gui/default.nix
    ../../home/packages/wm/default.nix
  ];
}
