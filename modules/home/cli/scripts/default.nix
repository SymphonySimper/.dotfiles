{
  pkgs,
  lib,
  my,
  ...
}:
let
  mkImport =
    path:
    import path {
      inherit pkgs;
      inherit lib;
      inherit my;
    };

  scripts = [
    "dev"
    "ffmpeg"
    "log"
    "nix"
    "unix"
  ];
in
{
  home.packages = builtins.map (
    script: pkgs.writeShellScriptBin "my-${script}" (mkImport (./. + "/${script}.nix"))
  ) scripts;
}
