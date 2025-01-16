{ my, ... }:
let
  customLib =
    { pkgs, my, ... }:
    {
      mkNotification = (import ./mkNotification.nix { inherit pkgs; });
      mkTTYLaunch = (import ./mkTTYLaunch.nix { inherit pkgs; });
      mkSystemdTimer = import ./mkSystemdTimer.nix;
      mkSkipUsername = (
        import ./mkSkipUsername.nix {
          inherit pkgs;
          inherit my;
        }
      );
    };
in
final: prev: {
  lib = prev.lib.extend (
    finalLib: prevLib: {
      my = customLib {
        pkgs = prev;
        inherit my;
      };
    }
  );
}
