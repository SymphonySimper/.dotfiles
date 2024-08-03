{ userSettings, inputs, ... }:
{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.wsl
    ../../system/default.nix
  ];

  wsl = {
    enable = true;
    defaultUser = userSettings.name.user;
    wslConf = {
      user.default = userSettings.name.user;
      interop.appendWindowsPath = false;
    };
  };
}
