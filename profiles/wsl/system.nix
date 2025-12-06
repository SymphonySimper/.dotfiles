{ my, inputs, ... }:
let
  interopAppendPath = false;
in
{
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  wsl = {
    enable = true;
    defaultUser = my.name;
    interop.includePath = interopAppendPath;
    startMenuLaunchers = false;

    wslConf = {
      user.default = my.name;

      interop = {
        enabled = true;
        appendWindowsPath = interopAppendPath;
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
