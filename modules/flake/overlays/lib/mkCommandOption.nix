{ lib, ... }:
let
  mkCommandOption =
    {
      category,
      command,
      args ? null,
    }:
    {
      command = lib.mkOption {
        type = lib.types.str;
        description = "${category} command";
        default = command;
        readOnly = true;
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
