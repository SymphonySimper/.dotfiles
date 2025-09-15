{ my, inputs, ... }:
let
  interop = true;
in
{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.wsl
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

  my = {
    networking = {
      enable = false;
    };

    programs.vm.docker = {
      enable = false;
      enableRootless = true;
    };
  };
}
