{ lib, mkGetDefault, ... }:
let
  # Opposite value as the filter uses a not condition
  types = {
    "dir" = "regular";
    "file" = "directory";
  };

  mkReadDir =
    {
      path,
      filter ? null,
    }:
    let
      filterValue = mkGetDefault types filter null;
    in
    builtins.attrNames (
      lib.attrsets.filterAttrs (_: value: value != filterValue) (builtins.readDir path)
    );
in
mkReadDir
