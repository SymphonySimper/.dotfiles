{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.wsl;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  options.wsl = {
    appendPath = lib.mkEnableOption "Append windows path";
  };

  config = {
    wsl = {
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
  };
}
