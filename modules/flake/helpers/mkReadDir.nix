{ lib, mkGetDefault, ... }:
let
  # Opposite value as the filter uses a not condition
  types = rec {
    dir = "directory";
    file = "regular";
    nix = file;
  };

  mkCheckTrue = v: v == true;

  mkReadDir =
    {
      path,
      asPath ? false,
      type ? null,
      suffix ? "",
      ignore ? [ ],
      ignoreDefault ? false,
    }:
    let
      onlyNix = type == "nix";
      typeFilter = mkGetDefault types type null;
      finalIgnore =
        ignore
        ++ (lib.optionals (onlyNix && ignoreDefault) [
          "default.nix"
        ]);

      files = builtins.attrNames (
        lib.attrsets.filterAttrs (
          name: value:
          builtins.all mkCheckTrue (
            [
              # checks for file type <regular|director>
              (builtins.any mkCheckTrue [
                (typeFilter == null)
                (value == typeFilter)
              ])

              (lib.hasSuffix suffix name)
              (!(builtins.elem name finalIgnore))
            ]
            ++ (lib.optionals onlyNix [ (lib.hasSuffix "nix" name) ])
          )
        ) (builtins.readDir path)
      );
    in
    if asPath then (builtins.map (file: path + "/${file}") files) else files;
in
mkReadDir
