{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.user;
in
{
  options.my.user = {
    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Username";
      default = null;
    };
    fullName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Full name";
      default = null;
    };
    home = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "User's home directory";
      default = null;
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.name != null;
        message = "my.user.fullName must be set";
      }
      {
        assertion = cfg.fullName != null;
        message = "my.user.fullName must be set";
      }
    ];

    home = {
      username = cfg.name;
      homeDirectory =
        if cfg.home != null then
          cfg.home
        else if pkgs.stdenv.hostPlatform.isDarwin then
          "/Users/${cfg.name}"
        else
          "/home/${cfg.name}";
    };
  };
}
