{ my, inputs, ... }:
let
  interop = false;
in
{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.wsl
    ../../modules/system
  ];

  wsl = {
    enable = true;
    defaultUser = my.name;
    interop.includePath = interop;
    startMenuLaunchers = false;
    wslConf = {
      user.default = my.name;
      interop = {
        enabled = interop;
        appendWindowsPath = interop;
      };
    };
  };

  my.programs.docker = {
    enable = true;
    enableRootless = false;
    enableGroup = true;
  };
}
