{ my, helpers, ... }:
let
  customLib =
    { pkgs, my, ... }:
    {
      mkNotification = (import ./mkNotification.nix { inherit pkgs; });
      mkSystemdTimer = import ./mkSystemdTimer.nix;
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
