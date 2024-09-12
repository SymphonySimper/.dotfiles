{ userSettings, inputs, ... }:
let
  interop = false;
in
{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.wsl
    ../../system/default.nix
  ];

  wsl = {
    enable = true;
    defaultUser = userSettings.name.user;
    interop.includePath = interop;
    nativeSystemd = true;
    startMenuLaunchers = false;
    wslConf = {
      user.default = userSettings.name.user;
      interop = {
        enabled = interop;
        appendWindowsPath = interop;
      };
    };
  };
}
