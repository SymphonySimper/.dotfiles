{ userSettings, ... }:
{
  imports = [
    ./cli/default.nix
    ./dev/default.nix
    ./editor/default.nix
    ./misc.nix
    ./shell/default.nix
  ] ++ (if userSettings.packages.include.gui then [ ./gui/default.nix ] else [ ]);
}
