{ lib, ... }:
builtins.listToAttrs (
  builtins.map
    (dir: {
      name = dir;
      value = {
        path = ./. + "/${dir}";
        description = "${dir} template";
      };
    })
    (
      builtins.attrNames (lib.attrsets.filterAttrs (_: type: type == "directory") (builtins.readDir ./.))
    )
)
