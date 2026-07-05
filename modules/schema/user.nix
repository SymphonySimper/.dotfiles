{ lib, ... }: {
  den.schema.user = {
    options = {
      displayName = lib.mkOption {
        description = "Full name of the user";
        type = lib.types.str;
      };
    };
  };
}
