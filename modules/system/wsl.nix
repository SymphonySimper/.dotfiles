{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.wsl;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  options.my.wsl = {
    enable = lib.mkEnableOption "Enable WSL";
    appendPath = lib.mkEnableOption "Enable append path";

    defaultUser = lib.mkOption {
      description = "Default user";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = cfg.defaultUser;
      interop.includePath = cfg.appendPath;
      startMenuLaunchers = false;

      wslConf = {
        user.default = cfg.defaultUser;

        interop = {
          enabled = true;
          appendWindowsPath = cfg.appendPath;
        };
      };
    };

    my = {
      networking = {
        enable = false;
      };
    };
  };
}
