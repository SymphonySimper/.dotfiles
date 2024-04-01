{ userSettings, inputs, ... }:
{
  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.wsl
    ../../system/default.nix
  ];

  wsl = {
    enable = true;
    defaultUser = userSettings.username;
    wslConf = {
      user.default = userSettings.username;
      interop.appendWindowsPath = false;
    };
  };
}
