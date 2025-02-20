{ lib, ... }:
{
  imports = builtins.map (file: ./. + "/${file}") (
    builtins.filter (file: file != "default.nix") (
      lib.my.mkReadDir {
        path = ./.;
        filter = "file";
      }
    )
  );
}
