{ lib, ... }:
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
      filterValue = if builtins.hasAttr filter types then types.${filter} else null;
    in
    builtins.attrNames (
      lib.attrsets.filterAttrs (_: value: value != filterValue) (builtins.readDir path)
    );
in
mkReadDir
