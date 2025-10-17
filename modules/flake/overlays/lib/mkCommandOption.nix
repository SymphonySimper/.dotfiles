{ lib, ... }:
let
  mkCommandOption = category: command: {
    command = lib.mkOption {
      type = lib.types.str;
      description = "${category} command";
      default = command;
      readOnly = true;
    };
  };
in
mkCommandOption
