{ userSettings, ... }:
{
  imports = [
    ./nvim/default.nix
  ] ++ (if userSettings.packages.include.helix then [ ./helix/default.nix ] else [ ]);
}
