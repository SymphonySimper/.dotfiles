{
  my,
  inputs,
  helpers,
  ...
}:
let
  customLib =
    {
      pkgs,
      my,
      ...
    }:
    let
      lib = pkgs.lib;
    in
    {
      mkCommandOption = (import ./mkCommandOption.nix { inherit lib; });
      mkNotification = (import ./mkNotification.nix { inherit pkgs lib; });
      mkSystemdTimer = import ./mkSystemdTimer.nix;
      mkGetThemeSource = import ./mkGetThemeSource.nix { inherit my inputs lib; };
    };
in
final: prev: {
  lib = prev.lib.extend (
    finalLib: prevLib: {
      my =
        helpers
        // (customLib {
          pkgs = prev;
          inherit my;
        });
    }
  );
}
