{ lib, ... }:
let
  mkCommandOption =
    {
      category,
      command,
      args ? null,
      readOnly ? true,
    }:
    {
      command = lib.mkOption {
        type = lib.types.str;
        description = "${category} command";
        default = command;
        inherit readOnly;
      };
    }
    // (lib.attrsets.optionalAttrs (args != null) {
      args = lib.mkOption {
        description = "${category} args";
        type = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            (lib.types.listOf lib.types.str)
          ]
        );
        readOnly = true;
        default = args;
      };
    });
in
mkCommandOption
