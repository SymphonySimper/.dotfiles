{ my, ... }:
final: prev: {
  lib = prev.lib.extend (
    finalLib: prevLib: {
      my = import ../../modules/lib {
        pkgs = prev;
        inherit my;
      };
    }
  );
}
