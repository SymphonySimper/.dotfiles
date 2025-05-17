{
  my,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    builtins.map
      (
        script:
        let
          name = builtins.elemAt (builtins.match "(.*)\.nix" script) 0;
        in
        pkgs.writeShellScriptBin "my${name}" (import (./. + "/${script}") { inherit my pkgs lib; })
      )
      (
        lib.my.mkReadDir {
          path = ./.;
          type = "nix";
          ignoreDefault = true;
        }
      );
}
