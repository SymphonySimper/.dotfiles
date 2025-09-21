{ lib, ... }:
let
  mkNameOption = category: programName: {
    name = lib.mkOption {
      type = lib.types.str;
      description = "${category} program name";
      default = programName;
      readOnly = true;
    };
  };
in
mkNameOption
