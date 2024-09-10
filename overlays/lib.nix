final: prev: {
  lib = prev.lib.extend (
    finalLib: prevLib: { my = import ../modules/lib/default.nix { pkgs = prev; }; }
  );
}
