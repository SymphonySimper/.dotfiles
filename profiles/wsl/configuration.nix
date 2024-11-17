{ my, inputs, ... }:
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
    defaultUser = my.name;
    interop.includePath = interop;
    nativeSystemd = true;
    startMenuLaunchers = false;
    wslConf = {
      user.default = my.name;
      interop = {
        enabled = interop;
        appendWindowsPath = interop;
      };
    };
  };
}
